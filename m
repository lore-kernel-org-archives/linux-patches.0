Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3FE14AD19;
	Mon, 16 Sep 2024 12:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488097; cv=none; b=ZvNZeZ2Voe7F7g2XmWKwU2LSks+gHL4bM3paNvMDeJuM4Y2gRvTkdKuqCkovf55TKKrl4j7W4PY9dIKI/3v7zWMRhO5bgbj78V9sgOkopAvziyL/jG/oU8EP5/P4irMPHJqszUglqPyDQyss/84xXZB0gb/XEa6j7hBXqjQIBeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488097; c=relaxed/simple;
	bh=0ngpE6t8k8Vp5iIxQ96zV7xvagS988eUk0sxSno4D3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yen/YeK5mfxtLAgxwZeuFmOy9W/2zCKDbw67VtKBlcJ0aBs3gnR1bjLG8ZDACR+RSPFUqRkfUYfZUFjzt/2b1P5oeSauDhRdjxtJ68Umer+nQNnyDhPXEt1H7aqa7NXcWba+W1X/w4mlIFOs05s2E8DU200e9Vq8W118rkuAxDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UiZbnnz6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UiZbnnz6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BB6EC4CEC4;
	Mon, 16 Sep 2024 12:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488096;
	bh=0ngpE6t8k8Vp5iIxQ96zV7xvagS988eUk0sxSno4D3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UiZbnnz6/siTpITcKAfvKysEO5V9etYOf+wEbJfY+7foq7YWsf8sjD9OA+J1oqOeh
	 YK/3X4vAw9TQfjUIzCWLplIh1tSMUWBKJOqAlel2KNT3RM7Vy4ZdKWVJhpMiHBe7TB
	 kgtC8rM/e49X3OdL2CITOrKVp8DVD0IOyeFWnqU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 57/63] drm/amdgpu/atomfirmware: Silence UBSAN warning
Date: Mon, 16 Sep 2024 13:44:36 +0200
Message-ID: <20240916114223.064244433@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114221.021192667@linuxfoundation.org>
References: <20240916114221.021192667@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 17ea4383649fdeaff3181ddcf1ff03350d42e591 upstream.

Per the comments, these are variable sized arrays.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3613
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 81f7804ba84ee617ed594de934ed87bcc4f83531)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/include/atomfirmware.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/include/atomfirmware.h
+++ b/drivers/gpu/drm/amd/include/atomfirmware.h
@@ -1005,7 +1005,7 @@ struct display_object_info_table_v1_4
   uint16_t  supporteddevices;
   uint8_t   number_of_path;
   uint8_t   reserved;
-  struct    atom_display_object_path_v2 display_path[8];   //the real number of this included in the structure is calculated by using the (whole structure size - the header size- number_of_path)/size of atom_display_object_path
+  struct    atom_display_object_path_v2 display_path[];   //the real number of this included in the structure is calculated by using the (whole structure size - the header size- number_of_path)/size of atom_display_object_path
 };
 
 struct display_object_info_table_v1_5 {
@@ -1015,7 +1015,7 @@ struct display_object_info_table_v1_5 {
 	uint8_t reserved;
 	// the real number of this included in the structure is calculated by using the
 	// (whole structure size - the header size- number_of_path)/size of atom_display_object_path
-	struct atom_display_object_path_v3 display_path[8];
+	struct atom_display_object_path_v3 display_path[];
 };
 
 /* 


