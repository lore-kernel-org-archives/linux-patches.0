Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2FD655E4C;
	Tue,  9 Jul 2024 11:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524712; cv=none; b=B0DtmVW8JXVKbCSMqUuSfxlcca1Z1WfgN4JjQ8ZNL9Bn3ZqSwKuNQiQ1Sm9LEFffyOEufM4TLJpeaG9Gl7wI+/otHM5zRxMsW0TmVyHnYZCSgBtI48b4AcZMoVS0UD8HcT4ljMYOa30luIRfRXpFMZKf+6QwYfOcn5H5C9FREi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524712; c=relaxed/simple;
	bh=CtWSSFhJtHpJT6Nd5AFILYPEXCLhUKb0J1jObw8DTD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZE+RsrCsxVOPCnXzN3/p0vXKv561Xd30V9UCsX0KQ+kqfxijM67p/aEE/v8bECmKD8jUDUvlYctPGTEma15Ui84zueKiPzFpJc/EwoA3ngj9bvYPg951+WXCLVfVOIHAlHv/IQmsRAvPyVNwAdKkbGB3Y0gKXeBC835+jIxznSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GdFXcWJn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GdFXcWJn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79CB7C3277B;
	Tue,  9 Jul 2024 11:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524711;
	bh=CtWSSFhJtHpJT6Nd5AFILYPEXCLhUKb0J1jObw8DTD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GdFXcWJn9KL+d/X0QTl0BduHSu5aK3WMHS5Z2dWrR7JylAgoqHtnLuM2JnhfG/gPW
	 NT+s6f0iUPyTcVomTF7HQE0KQz66hCn1ZAi2oJcms0iGJEbgsS6HmFN/3HTYBNFYW3
	 yJMbYaKDudfEVGTcEc+usKJQsnSPDj7SLdL0t1LI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 075/102] drm/amdgpu/atomfirmware: silence UBSAN warning
Date: Tue,  9 Jul 2024 13:10:38 +0200
Message-ID: <20240709110654.293303164@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
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

commit d0417264437a8fa05f894cabba5a26715b32d78e upstream.

This is a variable sized array.

Link: https://lists.freedesktop.org/archives/amd-gfx/2024-June/110420.html
Tested-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/include/atomfirmware.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/include/atomfirmware.h
+++ b/drivers/gpu/drm/amd/include/atomfirmware.h
@@ -701,7 +701,7 @@ struct atom_gpio_pin_lut_v2_1
 {
   struct  atom_common_table_header  table_header;
   /*the real number of this included in the structure is calcualted by using the (whole structure size - the header size)/size of atom_gpio_pin_lut  */
-  struct  atom_gpio_pin_assignment  gpio_pin[8];
+  struct  atom_gpio_pin_assignment  gpio_pin[];
 };
 
 


