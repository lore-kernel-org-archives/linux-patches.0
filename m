Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039688;
	b=VF/8GVbelIeudYhVDhbaUCrPilk4I5d0+4MWa5ltTvbXjfF7iw9Z7PaYKX3Un0wGgkte
	 V3jBjxCJxQOFNGTJHv0zZkKcfKMVkPYJAcd/PLXcJ+te5NQfkHLWy1OTi0FgU0VnHNsSo
	 Z2HlCsIau2MOHUdKvkJkcaFIfeI51/y54Ihi1fODldKHKkIyVRq1nLjfBtvcQjwSCAmRp
	 TuD2kZuV4dh8pzKOpTMJao54QKAFFnANW4KyAeOdRWCih2KiclYu9GRdEmKpVwHzzpRga
	 zcAqQoL6UDCcPCGrMtJ9RShlY4IxwU7x026Tn0CPWNGuQy/5HEswF4TORjgBR7S9wlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039688;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cuR1BzMPwH5KhF6dqLvAZXtdut7kDrD5C17LGdHNgLI=;
	b=gTyADNMAWaO4jFoPsBMcad/vH3ZJVH6nZy1JU6HI4P7Q1ANq+10yKEsa7ILeEdEzzdxL
	 SLm+AZiWdW8el8TKl0P4cxP/0V5kMuGaXr5Q7cmxUyBxZgyzHu7kimU9lHvOe5DEKJh42
	 TliCYBu5KKfE1LpZqqUcaq1yMLocBVJaz3rA/iWSB7V1F9s+bjygBhkhMuY7k8+81Mlph
	 wNwxDWcNJf+yaubm2CH+2V0crJm8W2+RcmRNlTKQ6GW7Gt9LzXhAKI2ra3L1Zh6cgO5SA
	 4pxPoIvOBpdS0qOSJEAGzoE/NKwJXjxsKxiLtIoD1qpG6nP3Rtdi7xUL5o3Hmv2DwZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KitQHICj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD8D606A31C;
	Wed, 18 Nov 2026 22:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KitQHICj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 386281F000C4;
	Wed, 18 Nov 2026 22:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039687;
	bh=cuR1BzMPwH5KhF6dqLvAZXtdut7kDrD5C17LGdHNgLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KitQHICjHXHEM6Ln2cY59CqeNy2RQcBHs+6br2FHA2uvQ76u6Dw4CnJql/ntIXYlZ
	 i1+5ylO++7iW+twLbgKAbXnucMqmSaa31sCeG0CDBzjtT63hT7ymJgOh7qOv/9yr22
	 j1c8JIX5vVksmkzqn80tpH8ogEG95f/M+mKrecXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2138/3318] efi/libstub: Fix efi_set_event_at() parameter documentation
Date: Wed, 18 Nov 2026 15:46:00 +0100
Message-ID: <20261118150426.203131103@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit c12a3a4b35e47fd511fbd550d3637318be41c4eb ]

efi_set_event_at() documents ids although its array index argument is
named idx. This produces missing and excess parameter warnings.

Match the argument name and fix the adjacent spelling of array.

Fixes: 8c0a839c2bcc ("efi/libstub: Descriptions for stub helper functions")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/libstub/efistub.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index 5ecb9d3f3e9f9..ccce54356a457 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -220,8 +220,8 @@ typedef void (__efiapi *efi_event_notify_t)(efi_event_t, void *);
  * efi_set_event_at() - add event to events array
  *
  * @events:	array of UEFI events
- * @ids:	index where to put the event in the array
- * @event:	event to add to the aray
+ * @idx:	index where to put the event in the array
+ * @event:	event to add to the array
  *
  * boottime->wait_for_event() takes an array of events as input.
  * Provide a helper to set it up correctly for mixed mode.
-- 
2.53.0



