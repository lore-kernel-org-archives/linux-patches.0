Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB5C4205D;
	Tue, 14 May 2024 10:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683065; cv=none; b=qtwrNjELWHxuDRj/ZikhtsSaEjn2mBlQCCAbtRkHPtp5LQlU55tFDZrXkETv2HqT4gztGBA0GkgwVk7YsVrvRA2eB4ou944oOati+4PrDM90gdvgQgE7SYUTIo1RpNwdL2LGhImVy+i7DFNjvCSPdrhOjfVmFNEj5D39Kyh8T+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683065; c=relaxed/simple;
	bh=q2rDFaJ1IRpdxIKV08Tj15KWEzs5Nyf8s73bXzhiG8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OrGH/BhIQbrRgQZTQwfGMamFwqnVjWrGwmZCEvj3kor5mjAVAKmk6Yi+b9XjaP3oToEzlLWD4lZllfZidGG0HzxLIkbH3bM1eOmlWC7B8t5oa2S05WtTjsjbJvr284/mw8eGbHQ3GH5ckyUAuk5DrjL3yrRT3Z2WCetcncPGro8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kJSHcDXw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kJSHcDXw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ABF5C2BD10;
	Tue, 14 May 2024 10:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683064;
	bh=q2rDFaJ1IRpdxIKV08Tj15KWEzs5Nyf8s73bXzhiG8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kJSHcDXwBYdJ9cVToaNsWQ4SxF9QuYOOR6TEF+zDg2/Ch6eJy7bGlzE3VRUOIyRrN
	 3iNqf4Jggdx4wNCnxDQ80PkFXRba53ZcAdjF1FIOuj5X6Rz2tl6o6x+EUh7YMqTfEy
	 Qr3IoXgAlePFD6qGBGADPIwZZlnJmXjqbT3ZEYng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Yang <richard.weiyang@gmail.com>,
	Yajun Deng <yajun.deng@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 143/336] memblock tests: fix undefined reference to `early_pfn_to_nid
Date: Tue, 14 May 2024 12:15:47 +0200
Message-ID: <20240514101043.999156108@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yang <richard.weiyang@gmail.com>

[ Upstream commit 7d8ed162e6a92268d4b2b84d364a931216102c8e ]

commit 6a9531c3a880 ("memblock: fix crash when reserved memory is not
added to memory") introduce the usage of early_pfn_to_nid, which is not
defined in memblock tests.

The original definition of early_pfn_to_nid is defined in mm.h, so let
add this in the corresponding mm.h.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
CC: Yajun Deng <yajun.deng@linux.dev>
CC: Mike Rapoport <rppt@kernel.org>
Link: https://lore.kernel.org/r/20240402132701.29744-2-richard.weiyang@gmail.com
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/linux/mm.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/include/linux/mm.h b/tools/include/linux/mm.h
index f3c82ab5b14cd..7d73da0980473 100644
--- a/tools/include/linux/mm.h
+++ b/tools/include/linux/mm.h
@@ -37,4 +37,9 @@ static inline void totalram_pages_add(long count)
 {
 }
 
+static inline int early_pfn_to_nid(unsigned long pfn)
+{
+	return 0;
+}
+
 #endif
-- 
2.43.0



