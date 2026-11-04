Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831212;
	b=p9qW5nG4CDRZIm8ZAhU420nBSVHaRIQjUJe5wsvwBsjtRgP9AbciJmjhCgcGh4avK2I2
	 ESAisE3oi1rFOt18cysQep139mgkJUe/p1EuIffUwE3lR/8IAwCmzpgJAdVkS+gG/n+KL
	 mlahZicv9fCwV8+mqjK8K7T/oz5BC4KrGYw5DAgGXT3jnUymhu7iP71JsbdWu60Jur8+t
	 BWHUazG450r4gSJVvvfYezjcmJEU1fp5A/r41B4kxfzl5ZbOtkMe8d3L/GOJK6deXyieb
	 0iq86ipmMcyHAfkCynRG9YR3FV8NjU1RnoozXYNW8PMcM5mVO1uWs+pZEl9XO+onWpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831212;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0+kmJ4BrKWPvZ6utRGKXpfNKQ5/pcYU25iULCwIMA/c=;
	b=4oZAMSarpW/yG0c9MuWh4FE7dWaNJI6k3UH2gW7o9g8YEAIImwANPVhoserhay5HUrlG
	 nbkqhDmKDaAxJhgOsYkVrecDTK5BhDxv8C0+kIbWwHRlunqSqQb6jDRsPkhDRCNY64UAD
	 U2QSAH6prFAY8ORgwMuU1V92BrNRjaJ5z/GR9ou6OPnPMejSit/NHUUz+Z2qKT9jQql5h
	 ZFTQvKVqChEvk0AACjOH/YmvlDHtsqRdUQH5qkIOn4C7UdXwh18QBWXh9Hj1LctyDti9Z
	 P4MZM6qOmrYIi6z/nLClWN+lOM1OfiaWGUePuj/q5qpwgeOP9mIBCFYmXvfdRMiVntQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Y/RCKdzJ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E17606A870;
	Wed,  4 Nov 2026 22:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y/RCKdzJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72DFD1F000C1;
	Wed,  4 Nov 2026 22:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831211;
	bh=0+kmJ4BrKWPvZ6utRGKXpfNKQ5/pcYU25iULCwIMA/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y/RCKdzJGBJ19YiyFsqNIqAvmjkQb3iOsQimPlqcGLYu3qGZSgvu8DWDQdCGDBNxD
	 5MikfvCBjkUyKjNKGUS+0dKt8M6Ed9qOuqdsbc+MZZAhi/HFaG97jIP326dr2PcwEv
	 2Nj1LLM3M1YAC+S6enHRTKF/Del7dq80PVzuDttM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dillon Varone <dillon.varone@amd.com>,
	Austin Zheng <Austin.Zheng@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0567/1005] drm/amd/display: Remove const Qualifier From Non-Pointer Fields
Date: Wed,  4 Nov 2026 16:05:00 -0500
Message-ID: <20261104211059.762645300@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Austin Zheng <Austin.Zheng@amd.com>

[ Upstream commit 93a77d353cb26772ae2fba50ae7321ae996b7f00 ]

[WHY/HOW]
Integer values for
dml2_core_calcs_CalculateWatermarksMALLUseAndDRAMSpeedChangeSupport_params
should not have the const qualifier.
This prevents using different values of the inputs when the
function is called again.

Reviewed-by: Dillon Varone <dillon.varone@amd.com>
Signed-off-by: Austin Zheng <Austin.Zheng@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 342280aae4f33816e8d07c15cb538a3b375a7f8f)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dc/dml2/dml21/src/dml2_core/dml2_core_shared_types.h      | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_shared_types.h b/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_shared_types.h
index bc64e3fd5f209..01a316e46426a 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_shared_types.h
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_shared_types.h
@@ -1737,8 +1737,8 @@ struct dml2_core_calcs_CalculateWatermarksMALLUseAndDRAMSpeedChangeSupport_param
 	bool UnboundedRequestEnabled;
 	unsigned int CompressedBufferSizeInkByte;
 	bool max_outstanding_when_urgent_expected;
-	const unsigned int max_outstanding_requests;
-	const unsigned int max_request_size_bytes;
+	unsigned int max_outstanding_requests;
+	unsigned int max_request_size_bytes;
 	const unsigned int *meta_row_height_l;
 	const unsigned int *meta_row_height_c;
 	const enum dml2_pstate_method *uclk_pstate_switch_modes;
-- 
2.53.0



