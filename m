Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E24B61F12F7;
	Tue,  3 Dec 2024 16:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242191; cv=none; b=DwrDbMeaatjQ7e68LLDGNvSKfoG0gvNKEK/zVYTfehOt4vLLFe9loHsIzFZ2viiE3cBFV5COQuKC1fcxlgXZFAgSfz4IUuLapBBQm0P5/JsxODmAtKmTYyfLDYgiKip1HwmsjvQyURnjXvPHjhALZODu2FLN4EXbguZ7k8fL0YA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242191; c=relaxed/simple;
	bh=5EaBEboskAQ6m+RCSjedVR20IWQQh86vPr2LgNo3v30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s5SKHadDDDj2ZblOb2oh+JZAzNnOUg3ppQYIkKttNNQh69KsiqiLX6YgHfkJdX0C2qJw/dcYC+lrm+ZdHec9j8NTI5nsQZz29YFzunfBYQhLgzeJZt4y71hvmafktK7wtun+ArGRUs3j0dUnUsU4t3e3h8OYLZI1Zo8fB/MKI1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=haiPUUKm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="haiPUUKm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DE3CC4CECF;
	Tue,  3 Dec 2024 16:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242190;
	bh=5EaBEboskAQ6m+RCSjedVR20IWQQh86vPr2LgNo3v30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=haiPUUKmZrOWFceslGMJVKTVigzYToO5K5eY3Vx7gjyTKwH8x9Scewx8r7Y6BzWrt
	 CRqa8PBlyotA7MF+anUuI3hsYpCuA5RYnjJVP6jTQnQEBoykhwNI3IfNhu3hjkKilg
	 V+EBCOhxCyY2u/y4znZSWmFm5x4wEDrwseB/044Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 633/826] docs: media: update location of the media patches
Date: Tue,  3 Dec 2024 15:46:00 +0100
Message-ID: <20241203144808.446618402@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

commit 72ad4ff638047bbbdf3232178fea4bec1f429319 upstream.

Due to recent changes on the way we're maintaining media, the
location of the main tree was updated.

Change docs accordingly.

Cc: stable@vger.kernel.org
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/media/building.rst |    2 +-
 Documentation/admin-guide/media/saa7134.rst  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/media/building.rst
+++ b/Documentation/admin-guide/media/building.rst
@@ -15,7 +15,7 @@ Please notice, however, that, if:
 
 you should use the main media development tree ``master`` branch:
 
-    https://git.linuxtv.org/media_tree.git/
+    https://git.linuxtv.org/media.git/
 
 In this case, you may find some useful information at the
 `LinuxTv wiki pages <https://linuxtv.org/wiki>`_:
--- a/Documentation/admin-guide/media/saa7134.rst
+++ b/Documentation/admin-guide/media/saa7134.rst
@@ -67,7 +67,7 @@ Changes / Fixes
 Please mail to linux-media AT vger.kernel.org unified diffs against
 the linux media git tree:
 
-    https://git.linuxtv.org/media_tree.git/
+    https://git.linuxtv.org/media.git/
 
 This is done by committing a patch at a clone of the git tree and
 submitting the patch using ``git send-email``. Don't forget to


