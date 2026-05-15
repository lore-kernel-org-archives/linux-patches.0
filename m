Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9347C374722;
	Fri, 15 May 2026 16:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861475; cv=none; b=Ui3gGYXIwzkS0WtZqjBvfTmYLtmttgv9tgp1DLUIkmelX2rN9gcrXd/y5oFM+n8wmv7DtGeS9JtafgxiDcxikh8i/RbK+mtBdBOJ0ErkyaPJVgUfEwKl9+8ueDY/g1RWaFFgmKLIV6HzK9EwobGvpXulbT1Sy64jZu4vuz4OBMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861475; c=relaxed/simple;
	bh=/3ZamfzBiJick07J7vI4TLjtXuYrOF+G0FD65QzTIFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0WCcinym6X/OuScapQOM5dS48TLhucMPsIMfZ9lX0AE3HOTkEpX6E0WIXn2DSBUkrGfZTXmtidXmCYzMAsuvYpkI+BasoapQzaX+WjUOOcc1YbbXo8bDEgou1jlahEh0pGYX5miw7m7AcCkiXzsyjVIpOSgrmh+Ds4m4DBUtfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QXfnpSZQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QXfnpSZQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 290F1C2BCB0;
	Fri, 15 May 2026 16:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861475;
	bh=/3ZamfzBiJick07J7vI4TLjtXuYrOF+G0FD65QzTIFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QXfnpSZQKLA1381e2rZq9NBcXzf5JGf5bvNa81xCTJVD1okyQ0/GnLU3+8H9VeJ57
	 1TNsWRYROgc35i9Ftp8hlsmgtYTATAc3iVkPjZAUOnXFTBiwVkk8annGwsRs76Qq3J
	 HZ2OxXtLmeYg3tafv9pE4gsq5RsLRrYUWjejkkkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Cheng <benjamin.cheng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 344/474] drm/amdgpu/vce: Prevent partial address patches
Date: Fri, 15 May 2026 17:47:33 +0200
Message-ID: <20260515154722.458824047@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Cheng <benjamin.cheng@amd.com>

commit de2a02cc28d6d5d37db07d00a9a684c754a5fd74 upstream.

In the case that only one of lo/hi is valid, the patching could result
in a bad address written to in FW.

Signed-off-by: Benjamin Cheng <benjamin.cheng@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c
@@ -654,6 +654,9 @@ static int amdgpu_vce_cs_reloc(struct am
 	uint64_t addr;
 	int r;
 
+	if (lo >= ib->length_dw || hi >= ib->length_dw)
+		return -EINVAL;
+
 	if (index == 0xffffffff)
 		index = 0;
 


