Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D445FB641;
	Tue, 16 Jul 2024 15:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144339; cv=none; b=LOkjfsl8kOAp5D3ml9eEs2yoG1unTLKHA+l4j/J1EIRvHRJWc9+CzqtrnOvXCmribjTE0OU1fJQ4kBWCeu16ASa94+ya/KQqPXr8m2o5kOC4m5M7NtbSoR5KaphpjXCxPS4eYYMGOGycjM91hGaspF0boJB3UWU2YdEZhR25dkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144339; c=relaxed/simple;
	bh=Zyc1bc/1aCug2rUGEDBNnJ1Gl7naFEEYS6jfEKzw7tk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BaYhp8h6cmfdn/ulBW0XngcDc7rhBjU7owDYCIjYqRE2fDfNlDtM4pxH4XplRC1UxMdCmzE3fOBBlI1dxelWnvifcB9TzefiIHoHnWJrHsW0hB/iPgL94yedSf9uajtIQQQoobk1ftFlvcmzl1GcjZmDZWRfqNCsScK6PZLxi9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KY5o2tDJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KY5o2tDJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A5EDC116B1;
	Tue, 16 Jul 2024 15:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144339;
	bh=Zyc1bc/1aCug2rUGEDBNnJ1Gl7naFEEYS6jfEKzw7tk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KY5o2tDJ2vSUnvQ2Hfi8Xd197t7U3axttLtkB9of5tMWOnGUSwb+zcCAZwL/NRcEZ
	 PRSCzq3FytkVkzGF5+rl37DuZdQpIFOqgo349FQvFR3yX/u6sBZM31fKiRQ83jAoMI
	 Wp5lE2EQuxYegKjP7THUXgbvgOohv8M9k4N+U+yA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.4 39/78] drm/amdgpu/atomfirmware: silence UBSAN warning
Date: Tue, 16 Jul 2024 17:31:11 +0200
Message-ID: <20240716152742.147794627@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152740.626160410@linuxfoundation.org>
References: <20240716152740.626160410@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -653,7 +653,7 @@ struct atom_gpio_pin_lut_v2_1
 {
   struct  atom_common_table_header  table_header;
   /*the real number of this included in the structure is calcualted by using the (whole structure size - the header size)/size of atom_gpio_pin_lut  */
-  struct  atom_gpio_pin_assignment  gpio_pin[8];
+  struct  atom_gpio_pin_assignment  gpio_pin[];
 };
 
 


