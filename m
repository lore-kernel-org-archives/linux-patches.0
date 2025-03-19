Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480D61D5CE7;
	Wed, 19 Mar 2025 14:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394958; cv=none; b=uRhbhNXGexXGBebnxsQG58PaGnt8vNbGdDnky2aDQYzaO/CKiSDBF9mdQ3ZsRT5T26+K1obwUK4OzB2BBi+aqFRFQTDP14fAJjQBK9s04hxWCAE/6hhQKVqBX77V9VQ/3WyKQETr74qmrT2PuQ81+ybnNwK3MBtGsW5tBOWubQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394958; c=relaxed/simple;
	bh=b49l/ssMd2ANf4SzlMzCgVWzcVneS14vxUhGfpxJiOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sQAuW7C10BZyDzlPF+ON6/KQGrQXiSnC2djzGQ4ja6zTFcFde7CvC7IyCwfDO9d2Q0K/+bZ7ZKVPBuVkXXViXD/3gbCi3MCykvKbK/CDrfptkC4KIHi8nwFhEMvkpgOst7Sj+JnjPTkefY/0XSVqD7kRHxArKOK8yHewAaafidM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rQXUZrNx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rQXUZrNx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DDA6C4CEE4;
	Wed, 19 Mar 2025 14:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394958;
	bh=b49l/ssMd2ANf4SzlMzCgVWzcVneS14vxUhGfpxJiOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rQXUZrNxpBsnONe28I0h6ZRa9o1+J3tX0Jrvb6CxcoDSN0JvvtVepL8oTZ286Pueu
	 fftF6yesH1GHum0WIs62FS09aALqdvHJBnXTp2uikbtmw+e/lmVnQPrLQHrVUSBtCc
	 wD1fqxoF2gBOCqTn/lGoiX+lY3f8QH5mQLttlxHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Aliaksei Urbanski <aliaksei.urbanski@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.13 185/241] drm/amd/display: fix missing .is_two_pixels_per_container
Date: Wed, 19 Mar 2025 07:30:55 -0700
Message-ID: <20250319143032.300328576@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aliaksei Urbanski <aliaksei.urbanski@gmail.com>

commit e204aab79e01bc8ff750645666993ed8b719de57 upstream.

Starting from 6.11, AMDGPU driver, while being loaded with amdgpu.dc=1,
due to lack of .is_two_pixels_per_container function in dce60_tg_funcs,
causes a NULL pointer dereference on PCs with old GPUs, such as R9 280X.

So this fix adds missing .is_two_pixels_per_container to dce60_tg_funcs.

Reported-by: Rosen Penev <rosenp@gmail.com>
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3942
Fixes: e6a901a00822 ("drm/amd/display: use even ODM slice width for two pixels per container")
Signed-off-by: Aliaksei Urbanski <aliaksei.urbanski@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit bd4b125eb949785c6f8a53b0494e32795421209d)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dce60/dce60_timing_generator.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/display/dc/dce60/dce60_timing_generator.c
+++ b/drivers/gpu/drm/amd/display/dc/dce60/dce60_timing_generator.c
@@ -239,6 +239,7 @@ static const struct timing_generator_fun
 				dce60_timing_generator_enable_advanced_request,
 		.configure_crc = dce60_configure_crc,
 		.get_crc = dce110_get_crc,
+		.is_two_pixels_per_container = dce110_is_two_pixels_per_container,
 };
 
 void dce60_timing_generator_construct(


