Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057986;
	b=P+uhXHQ/gKrgDiEtsTxB0BVkZk7qTDTIkW/HzllR/Qct69RVXhBiKgnxfUzcHzMjdbTY
	 ZZB5jkMnQznb4sfhtbrcnr1AaZjgnhNqzrVkywaTCe26PXJHUwIMreQNbZpahl2mR3dvi
	 oYY6F1xz6oAyblKG45bAJN1UugXUAugqzmcUKtEZYh/bs4v7VR2A/jRPvDlRw2ymm9yaB
	 JptKfWB61tJfuwGr8RX6pDLc60cxgzGO+MdwnZP1jZ+Jigz4OTW0zN++GMK3ZJlOxEi7+
	 U+D9etrSuQZh1kGeu/eoQrvU7sr5ZS7+TCLyy9f0sj0FwrpNEbSSNFYtuNyaD+g9Alg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057986;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A95g3VV0Mb3BA/AjlkN0xRpOxNVmYlmv6EqHPfS4KMI=;
	b=OzazdhImneoqmbzfXfZRvk9mOuUMYSpMxty8wd/uBCJPmMAJWjLFXjs/hlZSW0R4Yx6p
	 u8fr+9l3eFO/5UKVB4tBZw9fV9FX5m7F8LxC6/KRzBniQKGGyxSiVdwv5Iqxt2LCXoJpO
	 sW2N42I8C6BurxlsGtVHedLaYz73HAHAlh12h4/6nT1GYzkP9wsOxDheqyS5IQRbEc0hZ
	 0BYOI/16eJrrYQhYfBRYk021OirKJos50ug4IKkz0pGQPoW5biLjDeXaZvF5I33pA6x0h
	 Jr1LQXZXDuTKNgXFgd0z6HMXYh4BqYtRzs83Vy/cILOuSscTj9yggKrDmDgvnLmeHHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YHG6JdQP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809B0606A31C;
	Thu, 19 Nov 2026 03:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YHG6JdQP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA2611F000C4;
	Thu, 19 Nov 2026 03:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057986;
	bh=A95g3VV0Mb3BA/AjlkN0xRpOxNVmYlmv6EqHPfS4KMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YHG6JdQPx6mB4lQblEFsu5jtgX6cM/aC4bH4KqFkowp7gJi7qapCp6aHT1L9R6U4X
	 Fcp8B09Mfs+u+QY3Hcoi6kY5Pf+gQqWfC9trHW8onmXYSMs1b5y8VOZTIZpITR9Jda
	 retxvDJQn3xZyzWlgIt274vSQTwOa7pjXuMrkTNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 5.10 0308/1848] HID: cougar: reject short special-key reports
Date: Wed, 18 Nov 2026 15:39:06 +0100
Message-ID: <20261118145925.114044006@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

commit c6c0df8a4b73a0d563c5e64de640ef5ff525fc82 upstream.

The HID core invokes raw_event callbacks before validating the report
length.  cougar_raw_event() reads the key code and action from offsets one
and two without checking that those bytes are present.  A short report on
the special interface can therefore cause an out-of-bounds read.

Consume reports that do not contain the action field before accessing the
fixed offsets, consistent with the callback's handling of other reports on
the special interface.

Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw_event length validation to hid-asus.

Fixes: b8e759b8f6da ("HID: cougar: Add support for the Cougar 500k Gaming Keyboard")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-cougar.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-cougar.c
+++ b/drivers/hid/hid-cougar.c
@@ -271,6 +271,9 @@ static int cougar_raw_event(struct hid_d
 	if (!shared->enabled || !shared->input)
 		return -EPERM;
 
+	if (size <= COUGAR_FIELD_ACTION)
+		return -EPERM;
+
 	code = data[COUGAR_FIELD_CODE];
 	action = data[COUGAR_FIELD_ACTION];
 	for (i = 0; cougar_mapping[i][0]; i++) {


