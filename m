Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8362FB97B;
	Thu, 17 Sep 2026 15:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660335; cv=none; b=Yx4zBsyNVP/FjgkkukQnKYYKOE3x0oj7CLVYUEXqTLmx1QNRlZkHmoufsg9xzFw5Yhn4w8cm9hrjbV8/MJ7XA1FIEFZ2k9d9anRvJU+fCRGc0ABY9G4buyB9i5KI9k2KyiDuT9wY6PaXY0hk3SL7xNkHLrcTZ7t63inVUkv87s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660335; c=relaxed/simple;
	bh=XSlfuOrFIlLzMEEbh32IPV0KZ33fVGev3wV9O7kUMKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G8AzhCtM0zHi7nAbNrCs4Te7ZQTMA6dZULl0+o5XBqeARDPw5PV7JMXskWXdc6MO7u9EKeU3S91GnjLPM6xBGUx2YdpQDMM8/UwHUSpEQPMq4cxg9uPdYrthG7WPOIZ1f8cCAFRsdEhxUb+DnwsLYiddJ0zdV3pooVD/EdJqH+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tiM2GrEd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tiM2GrEd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39A1D1F00893;
	Thu, 17 Sep 2026 15:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660333;
	bh=2DwWT4OhmvQ10HvNzcCy8tSQlST/A8HYtas00F4XUU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tiM2GrEdVrZv65O3Ru77aNbz91iwyiNyWH1dRIoXhfyUtONsgrCECCmMOcLlOv/co
	 +DHhpg86CfbF9W5lpVk/gOie0NWwrciyCk54FkGcydr9KGMdZ05TCtLNNfI7EDWP19
	 deoT8f+yVLFg8FPNVswRse/Xh58i6Yxc2F9JFMiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <n.schier@fritz.com>,
	Nicolas Schier <nsc@kernel.org>
Subject: [PATCH 7.2 557/733] scripts/sorttable: Mark long_size as __maybe_unused
Date: Thu, 17 Sep 2026 16:14:25 +0100
Message-ID: <20260917151406.173415341@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit 4f73462856576797b8f3c55564a9be99f76dc67b upstream.

When building in a kernel tree prior to commit b055f4c431e3 ("sorttable:
Move ELF parsing into scripts/elf-parse.[ch]") with clang-23 or newer,
which implements a new warning under -Wunused-but-set-variable for
static global variable, there is a warning from sorttable because
long_size is unused when MCOUNT_SORT_ENABLED is not set:

  scripts/sorttable.c:452:12: error: variable 'long_size' set but not used [-Werror,-Wunused-but-set-global]
    452 | static int long_size;
        |            ^

Mark long_size as __maybe_unused to avoid inserting more ugly #ifdef
directives while insuring the warning does not reappear, as the
aforementioned change does not alter the uses of long_size, so it
appears to be coincidence that the warning disappears after this
refactoring.

Cc: stable@vger.kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Nicolas Schier <n.schier@fritz.com>
Link: https://patch.msgid.link/20260831-sorttable-long_size-unused-but-set-global-v1-1-8a96b88697e5@kernel.org
Signed-off-by: Nicolas Schier <nsc@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/sorttable.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/sorttable.c
+++ b/scripts/sorttable.c
@@ -116,7 +116,7 @@ static inline void *get_index(void *star
 }
 
 static int extable_ent_size;
-static int long_size;
+static int long_size __maybe_unused;
 
 #define ERRSTR_MAXSZ	256
 


