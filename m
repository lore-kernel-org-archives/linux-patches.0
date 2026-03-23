Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0274242D7F;
	Mon, 23 Mar 2026 14:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277924; cv=none; b=i5y2wUIFY0wF4gYqN0DfH+h6tQFSLxDU2RxAr/CECsBrcBM/QonSYo/n5ng00W7wSkjSne9xpFpIjWRctOaBe/EvSWsdX/lFqEYVJYIzdzrjPyrrcj+gYpDZD7KzCZwFKj0y1KSoVWuqB9+AbHOpvBbI9b4JvEBnEPe3sORt2lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277924; c=relaxed/simple;
	bh=TfXj9J0vSit4sQ8dkz+JQq2VCYKidvG4c7xj6e50DhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nszqqzwxpr1QbXh3393WD/Rvew8sOADDBkP69MwOeu+eePxC6zB8E8Myc0BGa9ZkGZZEUBXbYtBhuAfT6z5jzxc3Icp4MhyZPJ1O/FqFf6qGFSi67EpAndl4RPc9r7a+QebWirotJyuzYdvguz9yY18vvh9GMiVihLfzSol/g18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JVdwuTtr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JVdwuTtr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36763C4CEF7;
	Mon, 23 Mar 2026 14:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277923;
	bh=TfXj9J0vSit4sQ8dkz+JQq2VCYKidvG4c7xj6e50DhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JVdwuTtr0JhxUnG73xdsxcYVBHsb120P9I4tErN0UB3B5xiYmD5Jfth9xVA+tzuwN
	 kovCmNJudk42GGr8bUbmA2w+g2rzzRfxVv6TccXKHng0X/FIxP49kiETNgwp5AG94o
	 /zgKf5TU9BOiwZ/yvVRM60fLOv3WQHIkygLMmX2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olexa Bilaniuk <obilaniu@gmail.com>,
	Kurt Borja <kuurtb@gmail.com>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.6 102/567] platform/x86: dell-wmi: Add audio/mic mute key codes
Date: Mon, 23 Mar 2026 14:40:22 +0100
Message-ID: <20260323134536.348239325@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

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
 drivers/platform/x86/dell/dell-wmi-base.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/platform/x86/dell/dell-wmi-base.c
+++ b/drivers/platform/x86/dell/dell-wmi-base.c
@@ -80,6 +80,12 @@ static const struct dmi_system_id dell_w
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
 


