Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1FD44D487F;
	Thu, 17 Sep 2026 16:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663847; cv=none; b=fxpHSG+65IdmOKlphSwYW5Q4j9H3RouqV+Qe3HHYhVSP5R0eKcCrTMxgjRXgICirJQGTlQLYhujeTkNsSfcePxx4TyvkHiEDap5ZTMQExqZ92f2h4zQ9p/uW9g03g1PeHZVWgaevx7yv2H7E1oQtbXSfHUai68G9DBQrBZspDrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663847; c=relaxed/simple;
	bh=SdaKvdxysgjYMtZTPCASMhpDAWHGxGer04umnnz2Kq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ndHwE/sfqlmymMy+QISe1ZnV96/47hNkotfZEB4cERzzJYIRvGkHAMwlim2hJs8YWpf55CsiP29a4HdnlEiu8SkmL9j7DS89IvFjhB409fZ1brCg49PdJpuTrvCu4lm5TW/bdLMbuTEi7KFRqz3ZimR5ntyixC3jSGewX15yoIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ar94asGI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ar94asGI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEC911F000FF;
	Thu, 17 Sep 2026 16:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789663845;
	bh=RTPSt4NPdDS/bUIaExZ11e+4+feruoV47P0JvD/7E/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ar94asGIxb9DPFZeCnML4DbptVY0pIr4bUgw9qCZ9TAAx5HgHGV5RxiRUMzaKnffO
	 3uAjPnFKZsutXaa3yrG4TNn5cbJyqmfQ81GamcWw8yMWnVUifFhFkykCmyomlN7dkm
	 /agVjhU+ZDQYXQhP6Nwj+Ciq/dDlMHcAL8+9X4so=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alessandro Baldi <baldovic@virgilio.it>,
	Sean Young <sean@mess.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0125/1250] media: imon: Add iMON VFD HID OEM v1.2 key mappings
Date: Thu, 17 Sep 2026 15:58:40 +0100
Message-ID: <20260917151555.417971021@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alessandro Baldi <baldovic@virgilio.it>

[ Upstream commit d97d13c24d7893abcfb80d38630ce74daaa1434c ]

Add Vol+/Vol-/Mute panel button mappings for iMON VFD HID OEM v1.2.
This version differs in the codes that generate the
KEY_VOLUMEUP, KEY_VOLUMEDOWN and KEY_MUTE events.

Signed-off-by: Alessandro Baldi <baldovic@virgilio.it>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/imon.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 48534bb52e4d0..4f974b88628f0 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -290,6 +290,10 @@ static const struct imon_usb_dev_descr imon_OEM_VFD = {
 		{ 0x000100000000ffeell, KEY_VOLUMEUP },
 		{ 0x010000000000ffeell, KEY_VOLUMEDOWN },
 		{ 0x000000000100ffeell, KEY_MUTE },
+		/* iMON VFD HID OEM v1.2 */
+		{ 0x000000000a00ffeell, KEY_VOLUMEUP },
+		{ 0x000000000b00ffeell, KEY_VOLUMEDOWN },
+		{ 0x000000000c00ffeell, KEY_MUTE },
 		/* 0xffdc iMON MCE VFD */
 		{ 0x00010000ffffffeell, KEY_VOLUMEUP },
 		{ 0x01000000ffffffeell, KEY_VOLUMEDOWN },
-- 
2.53.0



