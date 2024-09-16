Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842F324B34;
	Mon, 16 Sep 2024 12:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488407; cv=none; b=ehY24xJ+YjjKxoPLYe2cUdAIbzqzLAKxBnCSnlQngOmGk/+rULc5jb4fQZo0ylyJiJzyhP1ODGucq91Gnb9Ct+VU42S8yMZXn7cHhlvk0814VPVV1IAIvqhUCXn6lx2o8DHkb/adSxZMyzzjyDJkj7Qy5InL4Mxk0rFWkEnl78Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488407; c=relaxed/simple;
	bh=GKlWtlpQuZDT2AaJMG5JEupvGWp6lP8NEK+66qgg7kg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qP+prQzXghh3LFHtFXM3EBPBbc4I5B3OwEK4eporoO738OZ6ZaJUWopY/FmhohbknA0qNamsUXOySLHO3ULJ+JmdFu/2E66uAvK3Hjk2RCiHc7GP0TR+mqnlcb+3zolMk+MNDts7XNX6GBUqZMJGZi+rAIAqUQoKeVhhaN7OFO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GdpUAtwJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GdpUAtwJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E9FC4CEC4;
	Mon, 16 Sep 2024 12:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488407;
	bh=GKlWtlpQuZDT2AaJMG5JEupvGWp6lP8NEK+66qgg7kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GdpUAtwJ++P4Kkj/xvJifKHVQOAizu4jMRu2z3w465XkVhYr7Jbpb2keSZgI3ifqI
	 BaoTgj/HeyrasBwu2DeQcG9C8B2cKnI9rV4YTLw5OgUY/ckcMkz2Op+Xqabh7TKpBz
	 XxxCWfc0daanpcByiDArLyeHigcD7M1UFuSHXByg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.10 103/121] drm/amdgpu/atomfirmware: Silence UBSAN warning
Date: Mon, 16 Sep 2024 13:44:37 +0200
Message-ID: <20240916114232.521537575@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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
@@ -1038,7 +1038,7 @@ struct display_object_info_table_v1_4
   uint16_t  supporteddevices;
   uint8_t   number_of_path;
   uint8_t   reserved;
-  struct    atom_display_object_path_v2 display_path[8];   //the real number of this included in the structure is calculated by using the (whole structure size - the header size- number_of_path)/size of atom_display_object_path
+  struct    atom_display_object_path_v2 display_path[];   //the real number of this included in the structure is calculated by using the (whole structure size - the header size- number_of_path)/size of atom_display_object_path
 };
 
 struct display_object_info_table_v1_5 {
@@ -1048,7 +1048,7 @@ struct display_object_info_table_v1_5 {
 	uint8_t reserved;
 	// the real number of this included in the structure is calculated by using the
 	// (whole structure size - the header size- number_of_path)/size of atom_display_object_path
-	struct atom_display_object_path_v3 display_path[8];
+	struct atom_display_object_path_v3 display_path[];
 };
 
 /* 


