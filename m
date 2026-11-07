Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061819;
	b=Ly46yXV7C6I2BD8F5dAPSmdwXkFjPyzpMmgPyIxQ/MXnssvj8DhU7jgQCgyrUCJtdEkT
	 aIGBibJQ74DlH+AUw7dKhqMjCRCz6PSf3a3RXOtDmmzeCR6mhH4pI1ppCCH3QGQvLlc9j
	 qf0E6Ct6Y4ssOkfi0bqrRCP+zdIR/ZHgSeo7WVL7tur1ZwO+J2NvTC4K8JOWNNRBIMXOM
	 0C2S8r+cOeOq5UMysh2hzrUub/0OAnQeY0rRxP5JVy+BacGoHNTGt+IN7xszPX5HDQJnh
	 09pL7cpMRbwkGdYPbX6IaJoP+ug/C6hTlxCAJAFjctR2XdURGYn4vcVhg/93o7iHw5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061819;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=30bYLqDb/KDC5zOawWSYM5zFk3pIrC7+YhbioiGWflg=;
	b=yo9KSdqCcl6iNjsxgr6B+lh70sSF7o4iFKXdXF+gziI9bjHHmfUd1Zj7g5K2miXAMmUi
	 OKScFBPfrJoSk0FS+CLme2T/1GZHyCgSehlOJsk8TL+S/riVSGUrFz6rCq/3gc4Q8N2+a
	 GO8JPqOMLuUnqL+PZinOSg5N4zCpiiVDsX3GONlkI8d9EWacQYAtyPegh9Kw22m2Mh2Y+
	 dAhVy7g4as2d4L4Oc6/8XUoAY4NprubsXDMTep/S1TA5zc3hQ80QwEAjRf+SXmePyXBvy
	 2Runz721qLNcp77/EHNNRurnigOmGMfWaeuuBzujaJ3V3A+p4In1ZyhyI+eaERf9ReQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LirEkqN2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE54606A326;
	Sat,  7 Nov 2026 14:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LirEkqN2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCB8B1F008A1;
	Sat,  7 Nov 2026 14:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061819;
	bh=30bYLqDb/KDC5zOawWSYM5zFk3pIrC7+YhbioiGWflg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LirEkqN2IxHc79enRI5C+ypksIHnh1vXYgvUKNtNfUKdbi0Rs0hWc0UqAW19GR3PP
	 cUR0vENHfqYk5QZpnN8KoACNkN8wulV4mL/Mi106DydDny/YRR7DwuTMx1Rf152KfS
	 Ygoqo5pGZ/J03CR/BrinKZjmSkeqD8Octt30mUEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.12 0826/1536] HID: roccat: savu: reject short special reports
Date: Sat,  7 Nov 2026 08:47:22 -0500
Message-ID: <20261107135020.742947968@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

commit 76c51fdc825a0486f8d88ff896d39acec8f377b4 upstream.

The raw event callback runs before HID core validates and zero-pads the
report.  It passes the buffer to a helper which inspects data[0] and, for a
special report, reads the complete struct savu_mouse_report_special.  A
truncated report can therefore cause an out-of-bounds read.

Require enough data for the special report before calling the helper.
Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw-event length validation to hid-asus.

Fixes: 6a2a6390cf09 ("HID: roccat: add support for Roccat Savu")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-roccat-savu.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-roccat-savu.c
+++ b/drivers/hid/hid-roccat-savu.c
@@ -182,6 +182,9 @@ static int savu_raw_event(struct hid_dev
 	if (savu == NULL)
 		return 0;
 
+	if (size < sizeof(struct savu_mouse_report_special))
+		return 0;
+
 	if (savu->roccat_claimed)
 		savu_report_to_chrdev(savu, data);
 


