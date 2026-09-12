Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7922DB788;
	Sat, 12 Sep 2026 13:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220705; cv=none; b=XIOhDzz0UiDem+DvcSYiRX4puByJx5WdgN23YkKjijlC71xuybdgcmwKtsVd/EzUliVlIZdnwrhg6iBvspsYHo9aua1XhEtreEpwU4zvOJ1DojrRP2thZghzcxlgt2VgtNAgptlo+gRxdj7/qSza+rj65RsqvzpeOYSIlCRobWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220705; c=relaxed/simple;
	bh=f647RdlNDgYNHsh98f6MZJpSOqh2NsHFILp7QULYAf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a3wdAPCnQ5Fu9+7k5/MnnfAxZ8sYEX8DCe86ga6cKnlQ6ZijG3OE4I2e5qP7qKv4H9P16TynkTo98ODcZerYkcjbR9Jqp2ytyamRTxIGNCsIpbYq+9MFIDgwaRSz2p9vSZ8o4Q6fxff3f9YR9Uek8rYdTEIoMHMveG+G8LgpjhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hZQLoZA1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hZQLoZA1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A5D31F000FF;
	Sat, 12 Sep 2026 13:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220704;
	bh=urqaz9eEQLEkP/RMY2F39i2RadXagXZSU2RpZIZFwPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hZQLoZA1Am/FrJctdRuyEB7QGimkeUkGuVMws7BLXAQSa6QJkl96Yhs4F2LBYH8q/
	 SQOYPpYKdton/oXQbdjujRkyNAouCboDGTLVRizgOAiKuS5bUQADP+yYxjKCpfnKkM
	 R0xVrqyMht6OIMUm7f2oK59cy+yosdcGSIT4id2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.6 0232/1424] platform/x86: dell-wmi-sysman: Dont hex dump attribute security buffer
Date: Sat, 12 Sep 2026 08:44:24 +0200
Message-ID: <20260912065612.477237924@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: HyeongJun An <sammiee5311@gmail.com>

commit 83c80495e45eddf64c6525fb582d8db68f256b71 upstream.

set_attribute() populates the security area of the BIOS attribute request
buffer with the current admin password via populate_security_buffer(), then
dumps the whole request buffer with print_hex_dump_bytes(). This can expose
the plaintext admin password in the kernel log.

The same issue was fixed for the password attribute path by
commit d1a196e0a6dc ("platform/x86: dell-wmi-sysman: Don't hex dump
plaintext password data"). Remove the remaining dump from the BIOS
attribute path.

Fixes: e8a60aa7404b ("platform/x86: Introduce support for Systems Management Driver over WMI for Dell Systems")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20260614045353.143500-1-sammiee5311@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/dell/dell-wmi-sysman/biosattr-interface.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/platform/x86/dell/dell-wmi-sysman/biosattr-interface.c
+++ b/drivers/platform/x86/dell/dell-wmi-sysman/biosattr-interface.c
@@ -84,7 +84,6 @@ int set_attribute(const char *a_name, co
 	if (ret < 0)
 		goto out;
 
-	print_hex_dump_bytes("set attribute data: ", DUMP_PREFIX_NONE, buffer, buffer_size);
 	ret = call_biosattributes_interface(wmi_priv.bios_attr_wdev,
 					    buffer, buffer_size,
 					    SETATTRIBUTE_METHOD_ID);


