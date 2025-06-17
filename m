Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A21622EB5AB;
	Tue, 17 Jun 2025 15:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174820; cv=none; b=NHVKFtadXTRmprN8a3ny9fWP1hnx9o6ARb9RDQKbDh91GWAinUyIv/QdVJW2Cz6Z+K9pmtGbEANWoghvWsiMZBgjkggt+U5k2tVm08ioZvh41wOqrlZ71JaHpALQsTBi9AU54pL6Wx2Ka7psM8G0tDv1nJ9oRUdNIbbhg/YeBHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174820; c=relaxed/simple;
	bh=bhEP4YNQpCQDoK2YccWpZtdtp1CnD/MdxIKCZIknLvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sejN1lNfuCYIr8dhZ2ep1gXGq7QtehqyT8GKZhqlMq80PhDG1kCCq79Fm3zgx9oPGGkVvloepjYneVZG3Ydbsap6e30+SgVC2M2LzJNlpfojCET9R28pTO8/M9ZdAVUQXR31AtSdTvPRayDFKvhyKGCU1WrdosqiWpAgc0TCxCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ktxpfjks; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ktxpfjks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1372EC4CEE7;
	Tue, 17 Jun 2025 15:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174820;
	bh=bhEP4YNQpCQDoK2YccWpZtdtp1CnD/MdxIKCZIknLvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ktxpfjks3GiI3kUApSXJlPUn9iHnbIIa51n19C2IEbr4rBXgoRzDaxfnFqlUB8EhA
	 9ggRmCX4uOVWGSxXinqDrSmiCFamkbDOX7/0Z96GjXm+uijYJl49V9cHNBB5tOhvCY
	 InBs1zFY7gqXtBMSGfB3P2IyMrWFS+pszLERlqek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Zhang <18255117159@163.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 116/356] efi/libstub: Describe missing out parameter in efi_load_initrd
Date: Tue, 17 Jun 2025 17:23:51 +0200
Message-ID: <20250617152342.897857666@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Zhang <18255117159@163.com>

[ Upstream commit c8e1927e7f7d63721e32ec41d27ccb0eb1a1b0fc ]

The function efi_load_initrd() had a documentation warning due to
the missing description for the 'out' parameter. Add the parameter
description to the kernel-doc comment to resolve the warning and
improve API documentation.

Fixes the following compiler warning:
drivers/firmware/efi/libstub/efi-stub-helper.c:611: warning: Function parameter or struct member 'out' not described in 'efi_load_initrd'

Fixes: f4dc7fffa987 ("efi: libstub: unify initrd loading between architectures")
Signed-off-by: Hans Zhang <18255117159@163.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/libstub/efi-stub-helper.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index 3dc2f9aaf08db..492d09b6048bd 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -561,6 +561,7 @@ efi_status_t efi_load_initrd_cmdline(efi_loaded_image_t *image,
  * @image:	EFI loaded image protocol
  * @soft_limit:	preferred address for loading the initrd
  * @hard_limit:	upper limit address for loading the initrd
+ * @out:	pointer to store the address of the initrd table
  *
  * Return:	status code
  */
-- 
2.39.5



