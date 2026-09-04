Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FEEC19CC0F;
	Fri,  4 Sep 2026 05:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499812; cv=none; b=HCoiOnYvHuTOhB0sK4Q9SMop8XB1X/7H7LjenOvxztaNckgN/rPxdu1Z3gka6wE7KHKs33fJcmjA0xmUVcSBsL5m/pgXgI+VR5DeTj+g4XL/iaz4F0TuNXL2Mp8XY9qGm+CjFCg7zG/DqJzM47buANfS3IvO7wIkvRHxhUAXls0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499812; c=relaxed/simple;
	bh=skPo/2NwrZWIE/coHCvVkpB5SFSQLpplN368wROLKCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QYev+nuyMb+lYLqPiDHo8iR+9w3TN9svg+yDLyIcIll8S47y5cx7Lv33W0dm3vdBnTpJ9qlVjW+NCj4QpErmIiQPLm5rroQELc8sRQwuNFy+bcw2HgT5q+1cximD4i/kOl+4/9mnVanE9zcWLtxIy6Jf1cFG+xaEztC3Wpep8cQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EL9w4KxR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EL9w4KxR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F8571F00A3D;
	Fri,  4 Sep 2026 05:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499810;
	bh=qzEpdLPFuxSAnEEGRWXJwcx3Pk3eTD6P8U5HCcpez5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EL9w4KxRQFhEZNLTtiU4nPh7H+YqjqcWSF0N0dCF5YXeSjPR2UhuvjZaemOzBC2DW
	 kuCmnffYNQrylJ11gffjJ5W+I9rEKl3f0QH+lmIpy4DdAgTwCxf++ZYUgydt1dhUVI
	 aDUaoy/avWyG3oiQH5AmV1IA/8cPrprJABKFtg+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 7.2 550/713] platform/x86: dell-wmi-sysman: Dont hex dump attribute security buffer
Date: Fri,  4 Sep 2026 06:58:38 +0200
Message-ID: <20260904045816.147679761@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


