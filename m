Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B4B37703B;
	Tue, 21 Jul 2026 22:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673025; cv=none; b=YIyCZoHLvttLg77cVHkrCz9E7BEoOPUKLGVNjXUzD9n3kLvoEYoa5fHxJlxkiuEiwfOsjTN5G/HjjGDKmh3AeoUTO4pCpodEzWAOUGRSPBBMdK5hdUJZPPTsXKSKskhjwb/RyOa7OwLNbXxWowecZCsc1okQ9DLa8lMgNQJpdjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673025; c=relaxed/simple;
	bh=lPpfuoAi1C/3CjzRdn80kFag6cUt/bdcuF/5TYR8sNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d6DXqJO1carn9AqnKIOisqVgpv73LkoV7Jr7EkRWuOBj4EKzvl5O4oGC+RYmLfVCY+e9D+nAuthfHXKI9v6nr+TK5r2PlRQhAkEi03s5qLNJpyNNXjUE148nCF1dIIe+8wl32B1YWcKPsyPcpJal3tPINP4H7I/sp0WjJ20YiJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kEtZK8dM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kEtZK8dM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E3631F000E9;
	Tue, 21 Jul 2026 22:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673023;
	bh=veH8Md48s6tCbg6gF4/J9h2HgkrGeeId7OI2X0OVigQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kEtZK8dMlp5KYUtJT0K+0zhZK/aT19pCnpYTiXvdV79dbsrV2BDAMPhW8OWwA+BrA
	 06qcDrPNtdQfkCBpjiac9NbiP+5Ibu2iOTtrAjZnuaVU56FlmvYMF8cdlb5eJ+G0JA
	 qfzSeSy1PS0yNljXZm5szXOi97CztTs1aDe2njRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Andy Yan <andyshrk@163.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 820/843] usb: typec: tcpm: Fix VDM type for Enter Mode commands
Date: Tue, 21 Jul 2026 17:27:35 +0200
Message-ID: <20260721152424.522163180@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Yan <andyshrk@163.com>

[ Upstream commit 9cff680e47632b7723cb19f9c5e63669063c3417 ]

VDO() second parameter is VDM type (bit 15): 1 for SVDM, 0 for UVDM.
Using 'vdo ? 2 : 1' corrupts SVID low bit when vdo is non-NULL
(2 << 15 = BIT(16)). Enter Mode is always SVDM, hardcode to 1.

Fixes: 8face9aa57c8 ("usb: typec: Add parameter for the VDO to typec_altmode_enter()")
Cc: stable <stable@kernel.org>
Signed-off-by: Andy Yan <andyshrk@163.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260604105059.18750-1-andyshrk@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -2223,7 +2223,7 @@ static int tcpm_altmode_enter(struct typ
 	if (svdm_version < 0)
 		return svdm_version;
 
-	header = VDO(altmode->svid, vdo ? 2 : 1, svdm_version, CMD_ENTER_MODE);
+	header = VDO(altmode->svid, 1, svdm_version, CMD_ENTER_MODE);
 	header |= VDO_OPOS(altmode->mode);
 
 	tcpm_queue_vdm_unlocked(port, header, vdo, vdo ? 1 : 0);


