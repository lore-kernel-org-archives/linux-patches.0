Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D8F4FDE62;
	Wed, 30 Sep 2026 16:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784135; cv=none; b=keseHk5FRGLRXBqvMztd5oUWz0wULOIBjTBKZ5NcXebOSWYG8ZTBCkqonYIQG9v18BOlNOvIdjObAvhXjtYll0k1d2et/kerCjwk09e9A3UpEMJuQHdjE6orxYJCv0f/fDBYlkkEuZgkCNC10bhiJ9ase7RVS7gijOMGt6Y7oWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784135; c=relaxed/simple;
	bh=yzIS2T+08Qd7lpVvwbABkEW4Inc+FLSBktMg2rvHCbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GrE3Q5q+0+h4hU8cTD56aivepiNnV/3shxndJPLOekrS87kS3WbMDRMZvfB2ZGbAaFwjU/bv4ZT3yx0+nd2JTicELokm4AJDYR5WxnKkZ+kAi5War7cbdBijkXrnNyU7CtiMsaI1Au0Sdh7KGB0VAgUp9HTPXQEAcwYW1Fq4tbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nteMgqcQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nteMgqcQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E9701F000FF;
	Wed, 30 Sep 2026 16:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784131;
	bh=LcZgWtkBPcA6lKw6fk0sL5foTJA7scDFRakZvhOtbS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nteMgqcQI0SXbzAuetq7fzwWsXq9dK4Rx07YobQh+4xkxTJyfkyhaSqzoDT92fhEN
	 3YS/tKKB/rIt61WHBokMijJrkb1QU0JL9DAbXFbJ7XkLO4dGh4KpY+gW4lGPddvSud
	 TV55CAX4AbmIquRwL8JWlcsrQVIuIiBdQ190vvH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alessandro Baldi <baldovic@virgilio.it>,
	Sean Young <sean@mess.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 047/982] media: imon: Add iMON VFD HID OEM v1.2 key mappings
Date: Wed, 30 Sep 2026 17:13:03 +0200
Message-ID: <20260930152417.806846323@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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
index bb4aabb08c06e..c6ef6d25871ad 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -295,6 +295,10 @@ static const struct imon_usb_dev_descr imon_OEM_VFD = {
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



