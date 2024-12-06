Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA45193;
	Fri,  6 Dec 2024 14:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496377; cv=none; b=EUD/8DghhDT6FqSHSXDczSj052ANsv8epbrn+4uC0YLcCQeD+NFf44OltcZmtWUlpFRNogCgsOP7LOp2XDws+NjBlZBupzyzqRBZibhBK7CNiMw6d2Ada1ZabKEGaPVCuQZoFPrcxJi4f/77Mu9zYjwpfjwErv6SElIikYYxkj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496377; c=relaxed/simple;
	bh=7MEA2xZfXm6GwS2ZnLRLJNDvk0n6kS2Klds+5tSqY9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G2ygzUYeSIEO0sIEPahGneFZAD+usqFL/i0mdYnvHrWYsxFhDecKeRy7WeiGaOktJ7yd/ocv/R3WJj6F0t+CA39ID5z0jGve0YG7tGEvux52y60ca8fCI/dZA6Aa/ku1SUuJoMvqoL6ehEKU17nbh6Dfsc/nR1aKLar4nCHSyx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QPuVt7G4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QPuVt7G4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0138C4CED1;
	Fri,  6 Dec 2024 14:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496377;
	bh=7MEA2xZfXm6GwS2ZnLRLJNDvk0n6kS2Klds+5tSqY9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QPuVt7G4Hi08x5pWdQj4KptOTTkNlBog3rPOaXD9ra50P6iIRGrY5UUMEbqgtCZuR
	 jVhNQhyzbLD/xdk3aybikhxHR04CBuuOtY4Gh56m8yHeiRcpA9K4q2URDNYqz9R36S
	 kSFlgj3h/3mdf0d6ilQeOeqPzeE9ptPNOWnogb+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 134/146] drm/amdkfd: Use the correct wptr size
Date: Fri,  6 Dec 2024 15:37:45 +0100
Message-ID: <20241206143532.813427055@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

From: Lijo Lazar <lijo.lazar@amd.com>

commit cdc6705f98ea3f854a60ba8c9b19228e197ae384 upstream.

Write pointer could be 32-bit or 64-bit. Use the correct size during
initialization.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_kernel_queue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_kernel_queue.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_kernel_queue.c
@@ -125,7 +125,7 @@ static bool kq_initialize(struct kernel_
 
 	memset(kq->pq_kernel_addr, 0, queue_size);
 	memset(kq->rptr_kernel, 0, sizeof(*kq->rptr_kernel));
-	memset(kq->wptr_kernel, 0, sizeof(*kq->wptr_kernel));
+	memset(kq->wptr_kernel, 0, dev->kfd->device_info.doorbell_size);
 
 	prop.queue_size = queue_size;
 	prop.is_interop = false;


