Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8DC1446AC;
	Mon,  1 Apr 2024 16:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988945; cv=none; b=c2rX/QTjD7fF+9MZs94+DiVIqsv35hWm022/5SDxbin67S6rZnndrzmSp9wOYyGFILHtqaccpCLTQ1M7XpUz5HxLZ73mQI2PcVB2j060K7cqZETQ1YEGKbGkb76p7pesdlbhIgWGV8MqeFJg9X6+dknEcECYhHVGKMJrWOD0t88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988945; c=relaxed/simple;
	bh=UwKLU2F9T+efHfGuBifNda3dWu8DKVRMXPPqVfoHS40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mNkErXRGIr8qY5y9SIfXiBe3qfVuxTDg59RHSD8U5lFnj4IsO1Y7kisgYtXn4UWKJRRFwGzB4ohC+R5Xn1HRHKOcLoEwmfD/2jEO/ohTj73ZCT7oNdnwWYYPXhmr9vHlt3YaMxIT53P4DchPd6ZuvoQU75HVMdJ+yZ2FCG/q8lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pv0O+U6s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pv0O+U6s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A79BC433C7;
	Mon,  1 Apr 2024 16:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988944;
	bh=UwKLU2F9T+efHfGuBifNda3dWu8DKVRMXPPqVfoHS40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pv0O+U6sBjegXx4gsbNCpLAOdqbIc2/V4dHtw+kzbH1lYKHfGMiT2KhKYk85VESr/
	 L5leYk15RxWt90IgL1MsaUXoHppxoZlPqVGLF0dHitwpJBygL1cn3SuUgHySQA0214
	 PvFCNVHcc/OHvxwUj5wjCUk3AT99RBmlJLGNYnss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.7 336/432] efi/libstub: Cast away type warning in use of max()
Date: Mon,  1 Apr 2024 17:45:23 +0200
Message-ID: <20240401152603.246495659@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

commit 61d130f261a3c15ae2c4b6f3ac3517d5d5b78855 upstream.

Avoid a type mismatch warning in max() by switching to max_t() and
providing the type explicitly.

Fixes: 3cb4a4827596abc82e ("efi/libstub: fix efi_random_alloc() ...")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/libstub/randomalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/firmware/efi/libstub/randomalloc.c
+++ b/drivers/firmware/efi/libstub/randomalloc.c
@@ -120,7 +120,7 @@ efi_status_t efi_random_alloc(unsigned l
 			continue;
 		}
 
-		target = round_up(max(md->phys_addr, alloc_min), align) + target_slot * align;
+		target = round_up(max_t(u64, md->phys_addr, alloc_min), align) + target_slot * align;
 		pages = size / EFI_PAGE_SIZE;
 
 		status = efi_bs_call(allocate_pages, EFI_ALLOCATE_ADDRESS,


