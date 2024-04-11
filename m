Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A9F148846;
	Thu, 11 Apr 2024 10:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831439; cv=none; b=I0sDZAsc7sHWY4dBFhG0JLc2xo+BPICxzHxmmVZoUk+wk0cYncF4Ac2oxNtl2K3bGxOf/pd3PiNmwIdnL3l09gz9UgMJQC8szJS9pQKQRKPEBfW3/mGnu7/d7XDualv/SbHHGBtj/PVTlKKPSivBf4LLZ3fY4X5xL8/0yuXnWyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831439; c=relaxed/simple;
	bh=uCiFoVU7C2P5SMpvl5uPn2M02bvIdr+hfO4BOX79ZTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d8rHMMAV7GoPpKzjAzFRJHAya8VpURhvo2+EK91NAnN/Up4SkWcLxMK4jy1+l0NEUf9+HWQ5WJPZbveyAVZ68gPwFfshdK8FLnRPrWLQbgGOMHLyUNk5v+R4hbmwFz7m//b/LJvx2MW2CBcLaQZAty8ChN3EYSjAE6VI8ue1Cxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RC5lZo7V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RC5lZo7V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5607C433C7;
	Thu, 11 Apr 2024 10:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831439;
	bh=uCiFoVU7C2P5SMpvl5uPn2M02bvIdr+hfO4BOX79ZTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RC5lZo7VXfNF3vwM3ODruiTtjadElYAespmgCLH4pi9zr0EM6Zmt+PG8rLilYBtIV
	 BixskPtprN9+xrBsmDTCgMo5kZYY1mUmmyLjADCV0HF67ZFmE8a50OL1MZ2QtQpJWo
	 B8F89aLUmCxTmdrjpe2RhSYZHsJf3WkuF4x/6RMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Yujun <linyujun809@huawei.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 5.10 001/294] Documentation/hw-vuln: Update spectre doc
Date: Thu, 11 Apr 2024 11:52:44 +0200
Message-ID: <20240411095435.681410207@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


