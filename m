Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8A61C3F0A;
	Wed, 19 Feb 2025 08:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954931; cv=none; b=pKuRm9BON38yaL2CgwiOVdNLIPN7WnjNVNQAs9N+QD7l2M5mHY8jE8hb5xzYav0USsFxpxiBK/3bOWSllrzjo3hPE6lP8ZIycykdiWLSaUm5SpChmcG3mvoalT1FbdC2khgpj2XPPhhystC+pSXeiISp9hWwqqaYcYG8YDrAl3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954931; c=relaxed/simple;
	bh=wR716H2lGHS+1xDLUBNgPogbCXhFPGCo84jpOXpjipM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Sz79kiYfrpygGw8ia3P+m4kDL6MauQ5lwdKPdGn8BwRUb2AdPXvfQOhZ9X9wdnA5Emuc/1U7JdTt3G/k4769UZDz+k5g3SXcKpnEbc0yEJvo7CEDD51L36yYSWw6bTsPLV8HX2vTl4EQ/vhUZwu1FfHjrosa4P2rKEv9pW7t7iA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jr/YpSHo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jr/YpSHo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CFC9C4CED1;
	Wed, 19 Feb 2025 08:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954931;
	bh=wR716H2lGHS+1xDLUBNgPogbCXhFPGCo84jpOXpjipM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jr/YpSHoEO4nL7kYLcwdGBPxjlX7RZkUhhP6XgH1zbGKo7hoYm9QZ7A5TEjd0HFVj
	 eokAHyb4bGwqAVd5N90TcxK+IfK0l/vc34QEztSTBQFeoiL41RDz3YeTtfXlFK3isA
	 KCu6NmFzrU22J4Ecmiiq8Du1mpyBI9ZjZhwCCjD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Brian Norris <briannorris@chromium.org>,
	David Gow <davidgow@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 080/230] kunit: platform: Resolve struct completion warning
Date: Wed, 19 Feb 2025 09:26:37 +0100
Message-ID: <20250219082604.832419831@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Norris <briannorris@chromium.org>

[ Upstream commit 7687c66c18c66d4ccd9949c6f641c0e7b5773483 ]

If the <kunit/platform_device.h> header is included in a test without
certain other headers, it produces compiler warnings like:

In file included from [...]
../include/kunit/platform_device.h:15:57: warning: ‘struct completion’
declared inside parameter list will not be visible outside of this
definition or declaration
   15 |                                                  struct completion *x);
      |                                                         ^~~~~~~~~~

Add a 'struct completion' forward declaration to resolve this.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202412241958.dbAImJsA-lkp@intel.com/
Signed-off-by: Brian Norris <briannorris@chromium.org>
Reviewed-by: David Gow <davidgow@google.com>
Link: https://lore.kernel.org/r/20241213180841.3023843-1-briannorris@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/kunit/platform_device.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/kunit/platform_device.h b/include/kunit/platform_device.h
index 0fc0999d2420a..f8236a8536f7e 100644
--- a/include/kunit/platform_device.h
+++ b/include/kunit/platform_device.h
@@ -2,6 +2,7 @@
 #ifndef _KUNIT_PLATFORM_DRIVER_H
 #define _KUNIT_PLATFORM_DRIVER_H
 
+struct completion;
 struct kunit;
 struct platform_device;
 struct platform_driver;
-- 
2.39.5



