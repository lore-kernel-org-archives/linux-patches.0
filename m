Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E224F218;
	Thu, 12 Dec 2024 17:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023320; cv=none; b=hIbMW+J1/JUHoQs9XJw/fvfmE3WpU9rQgt+wWWH3FV1xDMm8EUAgnGsOr79m1r3DZKVZJifYVNQo+H2ocuKBCEHb7VZsoJVaUKd2/OoPdqkhVUb2JtFkbTdfpRBz815FYJv8F1gtXSg4XSfd7tRouarJSW+PrnItehHv8JG+hFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023320; c=relaxed/simple;
	bh=G4ccLg4Yu9Wem+ohfKfbv6WKDUz2dJyVKVFvUONZcEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P/O12PCHRrtLnYZlsPSB7840qf0mY9mcwcPclY0hZh6XyHtClXwvOmmaDqQUkJpOJiPPmP2KKVXMm2AnnEvLDbjCGSmJMHwoSvjQD1L7DXyH9O24MAmLjfPZAA8HliZDEQRjnN4/al9PkHGG0lnPQXHnjhEWbjhYSdjF6e74L7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pnR8LCXL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pnR8LCXL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63EB6C4CECE;
	Thu, 12 Dec 2024 17:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023319;
	bh=G4ccLg4Yu9Wem+ohfKfbv6WKDUz2dJyVKVFvUONZcEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pnR8LCXLXdOruuj2mJw78kCJ5YfwQ/KpPi8pPZqkeJuzEVuhQJh77RtjVWkT9QhPj
	 812a3DbV39KxQfvC0yRmUsBpva9YuZp0Z+Zofor5S3Wc3gR86UI8zJ3+8XSOcyAUA0
	 fqo6H6GLV3/4VWOk11lnUQcjswF/Qp74GCQnfFs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prike Liang <Prike.Liang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 496/565] drm/amdgpu: Dereference the ATCS ACPI buffer
Date: Thu, 12 Dec 2024 16:01:31 +0100
Message-ID: <20241212144331.374859009@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prike Liang <Prike.Liang@amd.com>

[ Upstream commit 32e7ee293ff476c67b51be006e986021967bc525 ]

Need to dereference the atcs acpi buffer after
the method is executed, otherwise it will result in
a memory leak.

Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
index 592ca0cfe61d0..0adc992e4630a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
@@ -761,6 +761,7 @@ int amdgpu_acpi_power_shift_control(struct amdgpu_device *adev,
 		return -EIO;
 	}
 
+	kfree(info);
 	return 0;
 }
 
-- 
2.43.0



