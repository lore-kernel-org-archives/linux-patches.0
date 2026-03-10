Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB7738A734;
	Tue, 10 Mar 2026 11:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142027; cv=none; b=jzbpYEGEL6VGWi9798M/T2z2LZ3ppRQqi4c/aYnOdHWyUM9/ahmGaPg4sM6B519dePWNXXv0fMLK4KbfWaV3w9ylBx98hY9+dRcEewoScMs2LdfbIN++7Doig1ZDVhqK+tW5j/ECcOsHlda3wKkQeFXcL+jJHbwBQzAVRMz2isY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142027; c=relaxed/simple;
	bh=/PB/aL1LmfoCOZCbQN5F93cmNiinRup6YYizZMNnOHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IFajd5TXb/WImP+PZCcVb4l/Sanjr3wctY1K0YEGhAvlxm7gxF+qNLCJXWpis5sQz9nc3x52mtdOMwTqIwegF6LUvAs/X/cIXolhVHiUVD7KDKnzNHmVhHDXlo9g4kNpJpqCh9CmE9PAdm6wA4ltLgbwGr48oiNh9566UYeaLZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HUoesiYw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HUoesiYw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A655C19423;
	Tue, 10 Mar 2026 11:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142027;
	bh=/PB/aL1LmfoCOZCbQN5F93cmNiinRup6YYizZMNnOHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HUoesiYwVeYum8srTbxDouzJvK5gVL2VtnxMI1+w3FbNuQFLA29GnwQN6XmVUyvQ1
	 HFJqxuOHj0HBam37vPwWanHVRuQctRsq7seCKqGmN3bqIeEpTMXES3ZH85OTpFKSlc
	 G6QVy9N4t1KGIJ03C06O8/MUsOkubRxYyWiBxQTG8m63m170YNb5qT6ihk/tazjIF0
	 5MDE3pS6PRem5U260Hvk1tNcuBU1mwH+Gd5bGWrgkjSECoxsrIrkSwkk9ty47BBU6T
	 EB+XUfbGZWPRMr/8jwR0BP/NVwJ1Xw6zKufAeKBSUW31imlNmsud32Lc14AsDr5Cpw
	 nmvumw0eYiKgw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kurt Borja <kuurtb@gmail.com>,
	Olexa Bilaniuk <obilaniu@gmail.com>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.18 153/314] platform/x86: dell-wmi: Add audio/mic mute key codes
Date: Tue, 10 Mar 2026 07:16:52 -0400
Message-ID: <8800ee77285ea131049251d7d1fead5b81aa07ae.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Kurt Borja <kuurtb@gmail.com>

commit 26a7601471f62b95d56a81c3a8ccb551b5a6630f upstream.

Add audio/mic mute key codes found in Alienware m18 r1 AMD.

Cc: stable@vger.kernel.org
Tested-by: Olexa Bilaniuk <obilaniu@gmail.com>
Suggested-by: Olexa Bilaniuk <obilaniu@gmail.com>
Signed-off-by: Kurt Borja <kuurtb@gmail.com>
Acked-by: Pali Rohár <pali@kernel.org>
Link: https://patch.msgid.link/20260207-mute-keys-v2-1-c55e5471c9c1@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/dell/dell-wmi-base.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/platform/x86/dell/dell-wmi-base.c b/drivers/platform/x86/dell/dell-wmi-base.c
index 28076929d6af5..907f1da01c8db 100644
--- a/drivers/platform/x86/dell/dell-wmi-base.c
+++ b/drivers/platform/x86/dell/dell-wmi-base.c
@@ -80,6 +80,12 @@ static const struct dmi_system_id dell_wmi_smbios_list[] __initconst = {
 static const struct key_entry dell_wmi_keymap_type_0000[] = {
 	{ KE_IGNORE, 0x003a, { KEY_CAPSLOCK } },
 
+	/* Audio mute toggle */
+	{ KE_KEY,    0x0109, { KEY_MUTE } },
+
+	/* Mic mute toggle */
+	{ KE_KEY,    0x0150, { KEY_MICMUTE } },
+
 	/* Meta key lock */
 	{ KE_IGNORE, 0xe000, { KEY_RIGHTMETA } },
 
-- 
2.51.0

