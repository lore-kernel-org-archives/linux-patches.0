Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1559229CE7;
	Wed,  2 Oct 2024 13:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876733; cv=none; b=nNjVYGkKDoO9GvG6Qnj4JufDxszYGyZt21BO3zeZlbpg+hOA1Bdm5VZoBzQvHwWcdA0RZJFk6jeKNmsJPERfi4/Bck5ZUfbTYJusm9w25JgZNUkYjgTYB09WPPU8JnG8sm3KSGWATie38lctdpMozvHcvpmotoKLASvPv3sqYVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876733; c=relaxed/simple;
	bh=BJd0AotOxbJplvFycXXHpXdgEig7mfPwDC9jxi2NFIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d3mg5Rkmme8q91iT2xzHMsti9gI4B/1nhvDxD/g5Wcczlvwjrt6NZflK6t7Ri+ROyG5PrzRIgUdGHXafC6fyO2BKsx6LQNkD30xoll+ZsoHu9n7pX5ztjJEMhS1dKFmJbPd78e6ySSVf0b5+JBQ3U+OG5IGWP8oVbBEC8/vag9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B5ZTmx1E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B5ZTmx1E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90DA7C4CEC2;
	Wed,  2 Oct 2024 13:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876733;
	bh=BJd0AotOxbJplvFycXXHpXdgEig7mfPwDC9jxi2NFIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B5ZTmx1El4zOc4ELqmv1uWGJiBgRW1keKEikFUwyX0xTzOw7ULgYttFKeWQhO2mpw
	 ElxyjsOOjcqVIfqgQr6uYONxp47sQYv+UqrP3NKLUKQ4LRJ+pRhVQzyrsOde/nJIA4
	 QVOw/pXP5e8CvPuBttxFpqbto5Kmq5Dgi9PO85TQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Xiao <Jack.Xiao@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.11 544/695] drm/amdgpu/mes12: set enable_level_process_quantum_check
Date: Wed,  2 Oct 2024 14:59:02 +0200
Message-ID: <20241002125844.217656072@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jack Xiao <Jack.Xiao@amd.com>

commit 4771d2ecb7b9e4c2c73ede2908d7e7c989460981 upstream.

enable_level_process_quantum_check is requried to enable process
quantum based scheduling.

Signed-off-by: Jack Xiao <Jack.Xiao@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.11.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/mes_v12_0.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c
@@ -582,6 +582,7 @@ static int mes_v12_0_set_hw_resources(st
 	mes_set_hw_res_pkt.disable_mes_log = 1;
 	mes_set_hw_res_pkt.use_different_vmid_compute = 1;
 	mes_set_hw_res_pkt.enable_reg_active_poll = 1;
+	mes_set_hw_res_pkt.enable_level_process_quantum_check = 1;
 
 	/*
 	 * Keep oversubscribe timer for sdma . When we have unmapped doorbell


