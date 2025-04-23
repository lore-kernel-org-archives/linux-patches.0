Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD09D2853FC;
	Wed, 23 Apr 2025 15:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422296; cv=none; b=o8zm4cQrtIh6+Y+/TA1aseuq2AEcsUvYS+hDw01srgX0Ha05vgcqWklEVaSOhZWlWqgfabrmcD1lKAXMNfO/7JSHG1n+zXTp6/HjbjRIC0CJ+NjDbiFNrrv9N5V7aD60eagHiTBMdONVh+GyfJQvHqSY4XOyS41gDgtK9L+6HKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422296; c=relaxed/simple;
	bh=NCjzgEuhfvGHaRzDdD6//vZF1F7/nIFfbI7gKnpvXFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ewRQICDSgWapuQgDS9fnu76QDM2Lv8jfgbV26jlORfmsI83alYcKDKz8cLuWg84AMtvj7ijo8wiPoeypXxzV8S1GCUEI2omJmkFk3vrJ0dOcDPGuz6vRU2j4IGuYRQRAJoZcb3mAm4EsYcWtnT/aQhn172ciYiScBE8ghYcMS2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B14yEG1f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B14yEG1f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C35C4CEE2;
	Wed, 23 Apr 2025 15:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422296;
	bh=NCjzgEuhfvGHaRzDdD6//vZF1F7/nIFfbI7gKnpvXFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B14yEG1fhL5p6L5VLEz6w7w9HWAYyEAQgR7e6gbCG3BmaXY0KoB3i2n5y6AlcIGNZ
	 IRiwE5QsNSzlivZqKdwbwklCBXCpSQ6P6uxeQFCaZdF8Q+fEwFq3o4DGTSZLMMD7ou
	 AR3lyb6JMZMb7lPbTi2wst6ZlbEhHOdYxnckh58M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Salvatore Bonaccorso <carnil@debian.org>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 272/291] Revert "Xen/swiotlb: mark xen_swiotlb_fixup() __init"
Date: Wed, 23 Apr 2025 16:44:21 +0200
Message-ID: <20250423142635.542810413@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 1a95cff6e15945e8bc7a4e4cec9f9b85f0fb08e7 which is
commit 75ad02318af2e4ae669e26a79f001bd5e1f97472 upstream.

Turns out it causes build warnings and might break systems.

Link: https://lore.kernel.org/r/20250407181218.GA737271@ax162
Reported-by: Nathan Chancellor <nathan@kernel.org>
Reported-by: Salvatore Bonaccorso <carnil@debian.org>
Cc: Juergen Gross <jgross@suse.com>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/swiotlb-xen.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -112,7 +112,7 @@ static int is_xen_swiotlb_buffer(struct
 }
 
 #ifdef CONFIG_X86
-int __init xen_swiotlb_fixup(void *buf, unsigned long nslabs)
+int xen_swiotlb_fixup(void *buf, unsigned long nslabs)
 {
 	int rc;
 	unsigned int order = get_order(IO_TLB_SEGSIZE << IO_TLB_SHIFT);


