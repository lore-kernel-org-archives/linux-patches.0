Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4752C1A5;
	Mon, 12 Aug 2024 16:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480447; cv=none; b=UWS4+HF4ltOjrlz/ULEHCzQSu73wD9miPbioXQmkJXdJ6jypfiDlQ5gfC1vJP8jV7fmCXiCfmsjND8s3kKsC+l37HlZJXuG0+FJ+spm3aZ6yseMDOp2Z6qNritYmBeEUArqA0aBQYdshJeE6eGDEJlahn1pNf9S2J6WNwyyamXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480447; c=relaxed/simple;
	bh=4AKSP0osm8r8nBoYOTn2Ns+23mvsd4bi8rRnxoKRfKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XWo0H/vWXNN6BXRaPCACGuN9K3ZoEJcpsHJdJqk7cuBFgJjc6ZM2AsoGRuPXdi6vnlNmwMj2QI4ulZLWGllLI7b5ppoV+b4Y+VeMYUM0gjpoJuWCdfn6AH7TjKWCnvhDCywAPqY8eaA1lQRp/FiUi22GMAebCuf5PXimPQAzjcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tcsU+mmQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tcsU+mmQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B46AC32782;
	Mon, 12 Aug 2024 16:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480446;
	bh=4AKSP0osm8r8nBoYOTn2Ns+23mvsd4bi8rRnxoKRfKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tcsU+mmQwD4gNYze6zjvuM1wxRLE/08oZ4KkXe2Hy+tsqp/XT+sgSYEM9hfK/RiTi
	 A6ckfAX363slMFtqOyV8Y+9OHicSXnwf+hT7oF34Dp54VogBt3sUeGnMF9k5dM/G1P
	 jtsaiCoYdDY4rRrdTr1O4KKuxyz37LRTzlUGXx90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akira Yokosawa <akiyks@gmail.com>,
	Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.10 199/263] media: v4l: Fix missing tabular column hint for Y14P format
Date: Mon, 12 Aug 2024 18:03:20 +0200
Message-ID: <20240812160154.166508371@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>

commit 914f8961879de6fadd166ebd75151a778481e09a upstream.

The original patch added two columns in the flat-table of Luma-Only
Image Formats, without updating hints to latex: above it.  This results
in wrong column count in the output of Sphinx's latex builder.

Fix it.

Reported-by: Akira Yokosawa <akiyks@gmail.com>
Closes: https://lore.kernel.org/linux-media/bdbc27ba-5098-49fb-aabf-753c81361cc7@gmail.com/
Fixes: adb1d4655e53 ("media: v4l: Add V4L2-PIX-FMT-Y14P format")
Cc: stable@vger.kernel.org # for v6.10
Signed-off-by: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/userspace-api/media/v4l/pixfmt-yuv-luma.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/userspace-api/media/v4l/pixfmt-yuv-luma.rst b/Documentation/userspace-api/media/v4l/pixfmt-yuv-luma.rst
index f02e6cf3516a..74df19be91f6 100644
--- a/Documentation/userspace-api/media/v4l/pixfmt-yuv-luma.rst
+++ b/Documentation/userspace-api/media/v4l/pixfmt-yuv-luma.rst
@@ -21,9 +21,9 @@ are often referred to as greyscale formats.
 
 .. raw:: latex
 
-    \scriptsize
+    \tiny
 
-.. tabularcolumns:: |p{3.6cm}|p{3.0cm}|p{1.3cm}|p{2.6cm}|p{1.3cm}|p{1.3cm}|p{1.3cm}|
+.. tabularcolumns:: |p{3.6cm}|p{2.4cm}|p{1.3cm}|p{1.3cm}|p{1.3cm}|p{1.3cm}|p{1.3cm}|p{1.3cm}|p{1.3cm}|
 
 .. flat-table:: Luma-Only Image Formats
     :header-rows: 1
-- 
2.46.0



