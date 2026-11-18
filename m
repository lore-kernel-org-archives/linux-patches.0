Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051938;
	b=E2ENGbM0+TOC6gtBemTF1fuEU+7nu0oFmhr32g7HrZKTNzbbxg/soD7HrGTOMEAa4RX5
	 /AvVsB5/G33Qs9sa94Y+38cMShK5OcV0ayn3RdDRFlZ6yN4k8v4V9hVWu/BI8Hn822ias
	 J6NmNgY4LGqG6zH9ReXelgOJmDTPpqS7rZAVD9tbIjCnr6ywFoIQ4sEoO3yhWy3/1xD7a
	 SAkEWdoq9Y/xpcTBCQXZjwNnAdvvj03+2BqLXaT7++X+9vmQQNTgWWsFMzkaK2yCtcH98
	 6iBIzn7b1hkw8Wmy5mOiBRGtR+GSCmKwjP1lVqKX1Uu3fJYv2PEvg8DTQk1t78NX+yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051938;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6yC1k6VXT4LkjPz5N1x9xlO8JT/DRVThr4GkU0WIaSA=;
	b=x58FAz86/Fxf00NwRI2ryFVhwhHsdfWb3oOxf8aiIdAtoUFobmMYzWzH6p8WUXVVTtWI
	 hEsIFthGKkXxQg8hHVZ46EEQ3CltGk9mX+kxVgLWeoSwi7tLQ6kupDS0Z7pPA9zocntkM
	 BlA2rDoZEbNFRJQ7E4Etd2V+lXrFN0kuQABGcktvOnZ82RorG1kTZKoBzAA43QL0vcCft
	 V07hJ/Eq+gFK3aFyfRosnCH3gRJn0vJDrEDDVMwCU8Vllej4dt4Boc/ABwYiRkhPykbdL
	 acJL/125lKOlZkueDL/SSHQppwXev7vQ6mLxEL9M9b47R5DIZt+hwBwOGFM7JDSlA+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SHVo0KC6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341A7606A320;
	Thu, 19 Nov 2026 01:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SHVo0KC6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C4BE1F000C4;
	Thu, 19 Nov 2026 01:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051938;
	bh=6yC1k6VXT4LkjPz5N1x9xlO8JT/DRVThr4GkU0WIaSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SHVo0KC67ochQPYkz0O+KDjsNHf9s5nta+T1LFve7M9MY1IxekmDhUUCUXrXN1VGc
	 onZikYQW6CNlRLIQgnwhNRvk4DwFsFA3B7eGFEpM2SYXFiBsZlX/7G8EVSHaBSSxdn
	 e3WTG4acncrWzD7hEYc7qwsXGkwwCcf6QuRTYf58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 5.15 0386/2214] HID: roccat: savu: reject short special reports
Date: Wed, 18 Nov 2026 15:34:22 +0100
Message-ID: <20261118150026.121690240@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -179,6 +179,9 @@ static int savu_raw_event(struct hid_dev
 	if (savu == NULL)
 		return 0;
 
+	if (size < sizeof(struct savu_mouse_report_special))
+		return 0;
+
 	if (savu->roccat_claimed)
 		savu_report_to_chrdev(savu, data);
 


