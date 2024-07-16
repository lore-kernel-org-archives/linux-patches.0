Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81459F9E8;
	Tue, 16 Jul 2024 15:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144595; cv=none; b=FK5QTxilZAqPGOKCIPcdFiwmuRPaAvDl5E7q6/mto6hgoZCY/BrvEyB/lfYAJj73PIN3Oh3d9RhntyuUZfx0Js1+tKWM/NJOUSZKPLFAUCt4V5Qc3at+ONMieQS4o5CgPsQjdJI3XzREnR3fOE3mOTSFetpgNB/PDAlqZ3pgEVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144595; c=relaxed/simple;
	bh=BlQfTdrkdZXfpPgTyOG94oeYcMBykS/Leisn0ugbkL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dTdG5IEHxFolhhNKeuhFN0pkJqpQeSBIOCquBRkLduHfS/eIc3+vE+tWN3rBhrRBklxi/WyI/8ZOgCb+CKrTyIBW2qrgZ6LxGbmLDQ1YWq3GDq8L/YG+c6NOu+KTZYNCckGJvV2zVKs3wu0p3fcYQDVSEJXlMUKOh8w0J8Cscts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UT61kr8h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UT61kr8h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 065BFC4AF0D;
	Tue, 16 Jul 2024 15:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144595;
	bh=BlQfTdrkdZXfpPgTyOG94oeYcMBykS/Leisn0ugbkL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UT61kr8h115PCq3WE+l5pfVBot1orEo4LiormGwS9M6sI37OcK2Ke5xSMWqMRAM6b
	 hBFYpTKLrqoFGzuxu1w2tlftyocrJtaMp8OmnneN2/SecmWE8/mjrmHcCUUykIARRq
	 ixjY1CkO52YCwOCpmo8yQ/7wuRI3/HSYsGd5/BCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 043/108] drm/amdgpu/atomfirmware: silence UBSAN warning
Date: Tue, 16 Jul 2024 17:30:58 +0200
Message-ID: <20240716152747.646286104@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152745.988603303@linuxfoundation.org>
References: <20240716152745.988603303@linuxfoundation.org>
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
@@ -690,7 +690,7 @@ struct atom_gpio_pin_lut_v2_1
 {
   struct  atom_common_table_header  table_header;
   /*the real number of this included in the structure is calcualted by using the (whole structure size - the header size)/size of atom_gpio_pin_lut  */
-  struct  atom_gpio_pin_assignment  gpio_pin[8];
+  struct  atom_gpio_pin_assignment  gpio_pin[];
 };
 
 


