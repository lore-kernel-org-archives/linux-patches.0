Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4A9419FB0;
	Fri,  4 Sep 2026 06:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502726; cv=none; b=WmThAXArBAVMR5CdvR6lazOfTvAkr4am48LtZ9ReGNB4NnWvmjARzWsarsTYEtYY4JG8ZHhPbC/0k8XUXBGh0rJS9JF1QvJD+OynvvxfixRIuyJqfK1UEL19WhwrI+8gBpyfnMXdxwTTveodYxxrLDgswJKT/eBZ2xZkVnVHzDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502726; c=relaxed/simple;
	bh=FqV6wR3aTOG2u8XMT4E9xF6heEfGSXpgtwwOOzNW0ZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eGO8QofpMlJn+1eQP6X2vpD3QFXd9PHZISte7pTskP6bFP3y1MRexWafEiC7OBBCwWY9ySHH9SlmKHniFRm8QGs2TF2bXNf+ojJtq0sdlSqA3Srjyc8xwjbjvygc+LzAhHfX7GhG0rucniG+j2YM9foEe9IUiWw3GOcbl2mRvv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f7NQsGvt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f7NQsGvt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63CC31F00A3D;
	Fri,  4 Sep 2026 06:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502724;
	bh=X61L+BAZLRJw7/35afcf0rlKFAzlhnP4Id0HeSxS7uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f7NQsGvt7nLJ+HiaPUxmc/6QCyuUDoAPM8QzmV2C5ESX1U7mvmg4P6zXBty723v5Y
	 /eKkFXe/tCRxK4gY9WlDfPTZ+2hwqMBZvI96qEQ8o5K4trCQfYIbVzUtcRq04hihdq
	 5OAD4Ui4msQgJOgJfo1mtic2v3yB73k/mDfeE/7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.12 307/403] platform/x86: dell-wmi-sysman: Dont hex dump attribute security buffer
Date: Fri,  4 Sep 2026 07:01:50 +0200
Message-ID: <20260904045741.823982590@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


