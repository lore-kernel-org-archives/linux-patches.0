Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15CC413DDDD;
	Thu, 11 Apr 2024 09:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829502; cv=none; b=PVxju6xvX3nl5HRS5zB1KntSWk3HIMjQ0aKm3WxBmn9e0QqSqX5j3W/8cnWjZK4xAef9Qvw8Kapqmyeb6zbA1zZZnvtQlxg3yrC0P3JZjTUgYnLQ8a4Iur5fYy91Cgu2khGg9BX0s0r20kx8e2d60+7xpUhsc+1Tq4TSe3O2aqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829502; c=relaxed/simple;
	bh=9sZt5gAUZK/5ywk6rjr8fE8idDVQ0MA0xAjgQ1JuhbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o+G43RXiw1CaysYCLHoJdZHio93q4a6jjDNr+a1xcmKp7sMxEZux4Pyx+l+WblXWzvjCObR+Klbkx5Ld7IOHZCqzuhCRc0hzwB2BiCBGnlRE5mmn5Wbb3AgzfYasmIixwvhfkRJaLCJTB6HeKx07wqANH1w7gX+37MwrWufkvRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=enxN7mNb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="enxN7mNb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37682C433F1;
	Thu, 11 Apr 2024 09:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829501;
	bh=9sZt5gAUZK/5ywk6rjr8fE8idDVQ0MA0xAjgQ1JuhbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=enxN7mNb5qgwNSn2dyoGwinbP7Aa4vBLRwgAVpuHH7U5ojHfi5WH9hhq2EITZtryU
	 3/T9ebUAzzf/YZ/GbxCTS062oyI4BjKJva7zeHT2/g1dQzX0QRAj/OfHgdz0GcbVYv
	 B5pdSQ6GEfqwKlp2jsaNkFNTy2C2NvQu90sn2POw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Yujun <linyujun809@huawei.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 4.19 001/175] Documentation/hw-vuln: Update spectre doc
Date: Thu, 11 Apr 2024 11:53:44 +0200
Message-ID: <20240411095419.580385928@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lin Yujun <linyujun809@huawei.com>

commit 06cb31cc761823ef444ba4e1df11347342a6e745 upstream.

commit 7c693f54c873691 ("x86/speculation: Add spectre_v2=ibrs option to support Kernel IBRS")

adds the "ibrs " option  in
Documentation/admin-guide/kernel-parameters.txt but omits it to
Documentation/admin-guide/hw-vuln/spectre.rst, add it.

Signed-off-by: Lin Yujun <linyujun809@huawei.com>
Link: https://lore.kernel.org/r/20220830123614.23007-1-linyujun809@huawei.com
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/hw-vuln/spectre.rst |    1 +
 1 file changed, 1 insertion(+)

--- a/Documentation/admin-guide/hw-vuln/spectre.rst
+++ b/Documentation/admin-guide/hw-vuln/spectre.rst
@@ -625,6 +625,7 @@ kernel command line.
                 eibrs                   enhanced IBRS
                 eibrs,retpoline         enhanced IBRS + Retpolines
                 eibrs,lfence            enhanced IBRS + LFENCE
+                ibrs                    use IBRS to protect kernel
 
 		Not specifying this option is equivalent to
 		spectre_v2=auto.


