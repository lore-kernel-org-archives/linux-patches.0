Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7ED53B9930;
	Tue, 21 Jul 2026 21:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670805; cv=none; b=Fz6rc9fxCZUr4aWha4f9Va98NV2Qrs4DMME4cDpWLdPAHNm4+CGLUN67LiYkoNWP3shZ7nBYqBKtqkALBaWSHW4JMuR1xZtS+BQ74reKcMMdvMVpLgLwY8LnKTtHp7d9WCtzD2kqe8/YM7mHA6Ijpjsxu9wFj1yRgA2KcbwvwxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670805; c=relaxed/simple;
	bh=iLIaWGiskJ4OeMUTD5lOFrRVvpCj5KINAYazJVjFRzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CzVVZNhon6E6R5ziTvcqv3fBjiZk/6ybZFeF7CRRL9R2+PAMmpUyRxMpZS9yRAqaxhZo2BmTvm0oq99YgmOKzXRip/KTQ9x3HcIWK+y+rFl9fU3G1iTVf9Vdb/GsBS/Kn9qtXkQ7p00MnuGOaEKc1kb4vL0O8hqoR2VRc3jNr0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XOrR8ufT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XOrR8ufT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 446EE1F000E9;
	Tue, 21 Jul 2026 21:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670804;
	bh=QGKl9KTaFotmqCXUJ/bxhA86tke+aO9ucflXNCi8MwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XOrR8ufTbZRmdP4UkyY2fuQYP1woonoeBCRa6ncgkavPpUlJCKjm/eDXF7nl9Uqv5
	 PAXjLSHGzhtA4lE5vULX6zNoJtukKd1bOvtnWa1rMX0y+gTqQgku83Dt0xIYiTvtUo
	 u4lu7+KRlVJIM1iuNH5rrJHFX0YbT5+ixu/wmax8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Andy Yan <andyshrk@163.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1028/1067] usb: typec: tcpm: Fix VDM type for Enter Mode commands
Date: Tue, 21 Jul 2026 17:27:09 +0200
Message-ID: <20260721152447.571831274@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2231,7 +2231,7 @@ static int tcpm_altmode_enter(struct typ
 	if (svdm_version < 0)
 		return svdm_version;
 
-	header = VDO(altmode->svid, vdo ? 2 : 1, svdm_version, CMD_ENTER_MODE);
+	header = VDO(altmode->svid, 1, svdm_version, CMD_ENTER_MODE);
 	header |= VDO_OPOS(altmode->mode);
 
 	tcpm_queue_vdm_unlocked(port, header, vdo, vdo ? 1 : 0);


