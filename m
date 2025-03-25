Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2AD26FA6B;
	Tue, 25 Mar 2025 12:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906397; cv=none; b=Ik+ra1J9wAM4DtNRwVKaC/O+HVZFJNzulN7pLpWI8x4S/Y38e+qV1cuPNFB+1FUI93TSXR8qZJLs7PxRavuK3xckK9qq1JaOLMqiwwcoFcGQY5Mhy546OttL/s/WPCKGrnwk7/XuXoOQgGH6ZYXBfn+bedVJ5aQo3KUTIgfvrlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906397; c=relaxed/simple;
	bh=aQ14J8CrarrYkCs7u9EKGnARn+yGsK5O+h3NmjZVUfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uliSnnbOsLgUK/ifJXe13/gNZ+dEGtauOSgxswicy6xWj6/Y+/3gj4Jm6uKWSYdXx8lH8E3CQORivTg1hCMzOvSrdadUy5MqIUFqDyVasOprT7K5Qxi+jWd3fzDWvdaehcK6XAyVNL2dSSlqBtMkhu/kxPt9fnwAUUjom9SiFrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u3VxZZMz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u3VxZZMz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9013C4CEE4;
	Tue, 25 Mar 2025 12:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906396;
	bh=aQ14J8CrarrYkCs7u9EKGnARn+yGsK5O+h3NmjZVUfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u3VxZZMzNIJQ0r2Pi5eR+2c26hajFDSVp4oyw7hWlijAx0GbWWupjVNKFEYUBoijx
	 fSVk+0YmZSicqOMdNo3gS8aVJbvY/eKT8XMxa4x1NgSmt+4K2bvX+fWTaXl149lPbP
	 HYZzGfLGnTaFBRM52DZwtiKtRSUBp4iejCQXWDO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 094/116] drm/amd/pm: add unique_id for gfx12
Date: Tue, 25 Mar 2025 08:23:01 -0400
Message-ID: <20250325122151.612347852@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>

commit 19b53f96856b5316ee1fd6ca485af0889e001677 upstream.

Expose unique_id for gfx12

Signed-off-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 16fbc18cb07470cd33fb5f37ad181b51583e6dc0)
Cc: stable@vger.kernel.org # 6.12.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/amdgpu_pm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/pm/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
@@ -2493,6 +2493,8 @@ static int default_attr_update(struct am
 		case IP_VERSION(11, 0, 1):
 		case IP_VERSION(11, 0, 2):
 		case IP_VERSION(11, 0, 3):
+		case IP_VERSION(12, 0, 0):
+		case IP_VERSION(12, 0, 1):
 			*states = ATTR_STATE_SUPPORTED;
 			break;
 		default:


