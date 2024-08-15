Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65221ABEC5;
	Thu, 15 Aug 2024 14:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732954; cv=none; b=S0pOctNXeZKwRtvfvCElzbph9/8PrR4UWpQWSTWRHAUgOgmt1xJ3bxBKyYX6pukynk5A8yPZzgtg0MQVbkJGkmPuoadi+gtALt3dgGehiBe2OhWy7q7nd1r0iHVc3HMEyye6Zen/6Duf6qEZXLM65rKVBXOLGn/hQEowKeUOyfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732954; c=relaxed/simple;
	bh=eD5I8S2amrwl2WHYuHtJqPGLZuqes1Xdgh9vGVeyhfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vCQQqZAEjRRm5pHP98uI9ItrwN+43njcolE6XLWjQ5Qu4uRD9sEgvkpa17MaxGzvBIh3EyaGAQ0JhCo0OwwosDrn6nwNhxm+SKHUUaIY9RlT9DZgxA/d/WI9Jrmxhwl5OiqA/B8kbTFGpbkW234KqiiUW/MzNskfK1DsqepQVsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OdITphhc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OdITphhc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2309C32786;
	Thu, 15 Aug 2024 14:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732954;
	bh=eD5I8S2amrwl2WHYuHtJqPGLZuqes1Xdgh9vGVeyhfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OdITphhc46TgDNyd1XKNCuaV6heTmQo3lLg9+U2qvNT8NDm7zs1AvTAKGIWiljpem
	 8mAdJNHrPcH1Gyn+QED9bRd3XbkHHX2NcUilDgdB2Kl8sqwq7VTlU0CkEKJa2qtLUp
	 JNbD/xr/b1+Wjevz3z4SRIRJoUHi6wJI6yMObuNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jari Ruusu <jariruusu@protonmail.com>
Subject: [PATCH 5.10 337/352] Fix gcc 4.9 build issue in 5.10.y
Date: Thu, 15 Aug 2024 15:26:43 +0200
Message-ID: <20240815131932.489773567@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

From: Jari Ruusu <jariruusu@protonmail.com>

Some older systems still compile kernels with old gcc version.
These warnings and errors show up when compiling with gcc 4.9.2

 error: "__GCC4_has_attribute___uninitialized__" is not defined [-Werror=undef]

Upstream won't need this because newer kernels are not compilable with gcc 4.9.

Subject: [PATCH 5.10 337/352] gcc-4.9 warning/error fix for 5.10.223-rc1
Fixes: fd7eea27a3ae ("Compiler Attributes: Add __uninitialized macro")
Signed-off-by: Jari Ruusu <jariruusu@protonmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/compiler_attributes.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/compiler_attributes.h
+++ b/include/linux/compiler_attributes.h
@@ -37,6 +37,7 @@
 # define __GCC4_has_attribute___nonstring__           0
 # define __GCC4_has_attribute___no_sanitize_address__ (__GNUC_MINOR__ >= 8)
 # define __GCC4_has_attribute___no_sanitize_undefined__ (__GNUC_MINOR__ >= 9)
+# define __GCC4_has_attribute___uninitialized__       0
 # define __GCC4_has_attribute___fallthrough__         0
 # define __GCC4_has_attribute___warning__             1
 #endif


