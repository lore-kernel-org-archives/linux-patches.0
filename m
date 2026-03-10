Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37DB2BF3E2;
	Tue, 10 Mar 2026 11:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141121; cv=none; b=Icx638LTdJd2WPHs/LoZ/s3MFNTJ2sJJk40d7QJ67gEZzSPF01yJbefnXpx34WVrkfk94RiFIqM3fWtHUMnSa/6i9GZ3vAC2ifLeCutuMzaYFJLQKsrhAs7R8xhv2g51Uw3fNNmPwGZMRqpiJC2dXY9YZOeFt5HP15pQ9ZyOQI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141121; c=relaxed/simple;
	bh=/PB/aL1LmfoCOZCbQN5F93cmNiinRup6YYizZMNnOHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ECkWW0abGzrFkJz7CbPNXlxby4av/T1mqHX2AzswCFTtyYra+A6ncrspdUdoxjqgyi7GcKYRizp1/LNPNts49a/b9/YCz6m1eQMt4gfSCZqrcotXhDyldnRmG2nxazK6wVj9mUawW21IijVXALyNCzQj5mpjyNPxijSuTAOdbUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PR2Gcy/a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PR2Gcy/a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCC15C19423;
	Tue, 10 Mar 2026 11:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141121;
	bh=/PB/aL1LmfoCOZCbQN5F93cmNiinRup6YYizZMNnOHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PR2Gcy/aAzTTUHofL639zAALewZWVFw2foevXHSNyJxMQ9NvO587yclP1i3SPD6oN
	 oe5ZxK4WVfukRPMn1mFPWeWAK8ZzWTkf9CpycgX6nhKXnYoG970XmdREIurE4WAz38
	 QQuKnHV6G85dLoVssYCJJ0iHOrOx/r4q5XXou6zjNcNaBgxtjJRg6A2mXVOOzob1eI
	 P08aOGhlnPQet5F/t92+ILQzM0c275Rb3W6y3+XsZ+gkCpu+nsVV/7zvEaDXtUjceT
	 NrMFZJ4TnQAoDbjZMdmqAQzqzIgY+Ql4apFq6JvMi8aADp/KoAp336zinAiivRdU37
	 MXSX3eL05TM9Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kurt Borja <kuurtb@gmail.com>,
	Olexa Bilaniuk <obilaniu@gmail.com>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.19 123/311] platform/x86: dell-wmi: Add audio/mic mute key codes
Date: Tue, 10 Mar 2026 07:02:50 -0400
Message-ID: <b3329fa3d51762849e66f4d69610e33ccc906d63.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
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

