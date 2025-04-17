Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0ACD2566DB;
	Thu, 17 Apr 2025 18:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914174; cv=none; b=RMyKL6WdP2jjARXoiCsivyx1urCCKMQrdVeJy7Vf4V9C5aS+eQL7Bl2pe/3jOCly4w7WRe/SH+DztG5nOUJwnD1DzLIJrKxhYfIG3XsoZcsEbROr1y8skh+gPK1ZHsAHGddJpZ9Qb/xciTScsXu1xzCSer9Iwg+y+41hIgNAYRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914174; c=relaxed/simple;
	bh=Y9Eqfo1Y01ySo1ybDaymseV6TWKvonu1HuWr/lx5Ue8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QOfpBYw0b9QHNKObBI9DtrccavmiUi/6fgEcO+ATYrKY+aC56QXFlPpoW0Zp1TXZGqLWJApqwW6IY5XJqKILeRIwXxlvvTZpazjcxhuWYt5Bdt6Nr/ZcXrAnPdYLmU7aGpSCKJ9ZqCoHZNxSEBQZ9JoJcLY7m1vHIwL/mWoL+oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2nYFZzRu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2nYFZzRu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42570C4CEE4;
	Thu, 17 Apr 2025 18:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914174;
	bh=Y9Eqfo1Y01ySo1ybDaymseV6TWKvonu1HuWr/lx5Ue8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2nYFZzRu7M/CArM+wx41bKALd6fZlr9h3sp/9hX57fCUFliH01OUrV0kmU7h+y53N
	 YziakcitDqTm+H0Q2H4mMafm9xzgiIHe4baRWSC3jfn/jarSDKYi8ZcQsWBMvUzxTd
	 i+BfPEuhc/bM71dJVGLazIOw6sL1pRJEBKFLciKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shekhar Chauhan <shekhar.chauhan@intel.com>,
	Clint Taylor <Clinton.A.Taylor@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 130/414] drm/xe/bmg: Add new PCI IDs
Date: Thu, 17 Apr 2025 19:48:08 +0200
Message-ID: <20250417175116.660239195@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shekhar Chauhan <shekhar.chauhan@intel.com>

[ Upstream commit fa8ffaae1b15236b8afb0fbbc04117ff7c900a83 ]

Add 3 new PCI IDs for BMG.

v2: Fix typo -> Replace '.' with ','

Signed-off-by: Shekhar Chauhan <shekhar.chauhan@intel.com>
Reviewed-by: Clint Taylor <Clinton.A.Taylor@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250128162015.3288675-1-shekhar.chauhan@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/drm/intel/pciids.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/drm/intel/pciids.h b/include/drm/intel/pciids.h
index 32480b5563db3..3a89f6bb8ee55 100644
--- a/include/drm/intel/pciids.h
+++ b/include/drm/intel/pciids.h
@@ -817,7 +817,10 @@
 	MACRO__(0xE20B, ## __VA_ARGS__), \
 	MACRO__(0xE20C, ## __VA_ARGS__), \
 	MACRO__(0xE20D, ## __VA_ARGS__), \
-	MACRO__(0xE212, ## __VA_ARGS__)
+	MACRO__(0xE210, ## __VA_ARGS__), \
+	MACRO__(0xE212, ## __VA_ARGS__), \
+	MACRO__(0xE215, ## __VA_ARGS__), \
+	MACRO__(0xE216, ## __VA_ARGS__)
 
 /* PTL */
 #define INTEL_PTL_IDS(MACRO__, ...) \
-- 
2.39.5



