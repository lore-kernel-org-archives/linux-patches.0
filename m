Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6711DED6F;
	Wed, 19 Feb 2025 08:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954097; cv=none; b=JiBglnWy+IJflEJqgSWLRN5MWyR0FqlyHT8KRLAW86QPxauf7Sbl6xLc6Cf98qrLa1iX8h1r1zi+urNsoG4AsXbYIAzbOssGt3cbQDVpGAHftMPYSsVv7hqTmzqRtwguYpCSUS4Chzjci2mJKuFROaav+MMKxrr2kTbRxSQxH7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954097; c=relaxed/simple;
	bh=XAJ1IlWvtrjJyT4SBQQ6GkROPlcGbyTJ1jQIe+umNd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g3U/lM4rZBCGFAes679mRpjuOapAgx5knM1UqioqAtpdnz02dVw+YEv74kG0bX52RJnM+H5n9QIaZ+qKq0SRWk/IBEb+2Vnr9ZkxIqAEDJuCaqYStMh9B8NRS2buSl5dum3+TsvXtvmvBXbZmy9/VZ9PggEvaPIGeHPhvf7A0xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SJwiKE5U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SJwiKE5U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2347C4CED1;
	Wed, 19 Feb 2025 08:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954097;
	bh=XAJ1IlWvtrjJyT4SBQQ6GkROPlcGbyTJ1jQIe+umNd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SJwiKE5UysgQzSDz0E5NRpxjUNzjRJ+FQ1Et7/w/HhwfbBVWMz12uTyVus/cqeEKG
	 Q1jrFowJiRfj3pi+QEALaiG/6fcqryGEn3qS8SyPCSBGQGB8sYzNgairqNUV/cpK2I
	 f72zpx3ZctfrluEZLSvFim+/oJ0x5I6DX6dQrPJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Brian Norris <briannorris@chromium.org>,
	David Gow <davidgow@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 095/274] kunit: platform: Resolve struct completion warning
Date: Wed, 19 Feb 2025 09:25:49 +0100
Message-ID: <20250219082613.342924828@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



