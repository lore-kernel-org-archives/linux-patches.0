Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E01023570A4;
	Wed, 28 Jan 2026 15:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614088; cv=none; b=frDfpYyesCWt1XguC7o27Erz6EPilCsseMLzzVxuq5nuIT6mKxA3ehmT/n0yVCR7RZQULQFDe6/nPydaq2Zt5UE/BSaYWhgplZXlqKYu+a6HFAIcZ3V+A8tWma436cdX7VfIq2FQTB/dLWniCfEXYjillbvveiHDTLbEV6yxrOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614088; c=relaxed/simple;
	bh=0zZzeAT17Duh4X9UowNQGCj8K2DhjzhSXBgU3iN4lPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hFMO+fOtv1/1LIsKW4WTgB+/LbfZeW6MqHqjVuNQzR9WwMYvaSGUkh/Y2EZXeiR/V3K/wTqtcXd9hiaSsHMlhalNKh6ABM2EGpUAc/StvJYtCAxpZip//867OWuFFjqDOVM3YfQ4bypUkoAdYAoAjJggH+c7v3L1RILsE3vuNvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pmqtYXPZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pmqtYXPZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E20C4CEF1;
	Wed, 28 Jan 2026 15:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614088;
	bh=0zZzeAT17Duh4X9UowNQGCj8K2DhjzhSXBgU3iN4lPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pmqtYXPZWJT2fJq4ZexDxsXXD0M/biuwVTMXSwOe1WQp+HCEEjdRGw/j5yo65AiB+
	 if3KTQkaW6EmeCj91c+pY9fuGs5bZ0TVHzFMLl/+c0TgRAtYD4NU3Wmd2SEwyMYVCq
	 HPIkMWE1XXTt6DPPSKw1Vo2ZsOGsK7BWxzTDo8Vo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Marco Elver <elver@google.com>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Harry Yoo <harry.yoo@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 031/254] mm, kfence: describe @slab parameter in __kfence_obj_info()
Date: Wed, 28 Jan 2026 16:20:07 +0100
Message-ID: <20260128145345.822770897@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Bagas Sanjaya <bagasdotme@gmail.com>

[ Upstream commit 6cfab50e1440fde19af7c614aacd85e11aa4dcea ]

Sphinx reports kernel-doc warning:

WARNING: ./include/linux/kfence.h:220 function parameter 'slab' not described in '__kfence_obj_info'

Fix it by describing @slab parameter.

Link: https://lkml.kernel.org/r/20251219014006.16328-6-bagasdotme@gmail.com
Fixes: 2dfe63e61cc3 ("mm, kfence: support kmem_dump_obj() for KFENCE objects")
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
Acked-by: Marco Elver <elver@google.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Acked-by: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/kfence.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/kfence.h b/include/linux/kfence.h
index 401af47575141..90edba2e59f95 100644
--- a/include/linux/kfence.h
+++ b/include/linux/kfence.h
@@ -211,6 +211,7 @@ struct kmem_obj_info;
  * __kfence_obj_info() - fill kmem_obj_info struct
  * @kpp: kmem_obj_info to be filled
  * @object: the object
+ * @slab: the slab
  *
  * Return:
  * * false - not a KFENCE object
-- 
2.51.0



