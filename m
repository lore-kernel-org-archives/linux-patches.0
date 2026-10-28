Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213858;
	b=tZ8SW9heDgu69n/MnLQch41MZQRprYiChtQWwqkJxEj28fMvfJfd9JsXjmh6DkJSnHED
	 iLxhUC6JacAQqus17tQttrlN3zKxUJl5iMVl0aGbJPvgjSai9lXiqI/xIdKdYm8MBxZAu
	 IXtx0Uki5KhY7lkkpPl5qT+2yJLffM7u3f5Bbhop+q+6Hkd2AqiURJ40C0eyYngSd7Oby
	 ZGofYnLplNkdalgWGk1P6LS9yQtJdXbiJiG2TudrYV92cw1bQFOJ/ftx77yl8FJpSoUkq
	 8PFQl+t/evNwvy5FIZEEMdFlslDgAFi9/HAtGApG3m/ep5oK4LXHZOeC2nkYpuOinww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213858;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tXZZcEseIwLawWvOv24PDfplxQIl30Z//K6yA32FB+0=;
	b=n2/6VyntDEA/tITuvtd9nAgzccVzquz1X9mFmBmrI8Qnh5NbF6+9q2oEPzpU2HfFXuSY
	 pnldrZPxoXNYW85FCQcId9MiAUt28JRPf2rBmANjmqMnSqIKWVa5iUo1mOH83PFO9WziX
	 RQeQzeHq+mLyYZWyx9VEU2Ph4WyXb32D8sT8OENc1vsY8WucjD7xfL/bREUfnkPnN6e5S
	 fHtS3RamUdOZquixeoswhMDk1zFRFetLbE6QuFyL86ufU2EJgRCI2LlKxOgZsVfXk1an7
	 FTaYsXiZ4k/gwP9kRrm2o/+/Ypyb3pjwj/hisiQolDf9UH5CyP5yOChDIP8PD6jOYgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="cu//Zz5e";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16133606A31C;
	Wed, 28 Oct 2026 18:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cu//Zz5e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F16B1F01825;
	Wed, 28 Oct 2026 18:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213857;
	bh=tXZZcEseIwLawWvOv24PDfplxQIl30Z//K6yA32FB+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cu//Zz5etDC9fmI8mwFKQ2EfH0k++ADKHkxUfyqpYGhrGP8e3jS/qBsuCm9kfQbfm
	 VkiAnPQWzIX19zv3IButJYa3zklvQNDsFOiFwaYQDQnCa+2EWbAg1hbiHyE/Owow8q
	 rGK+0XnjR233rNI+b7k0gjWfITawXrZVgHF0JAUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Hersen Wu <hersenxs.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0653/1887] drm/amd/display: Add missing NULL pointer check within dpcd_extend_address_range
Date: Wed, 28 Oct 2026 17:45:49 +0100
Message-ID: <20261028170514.272129485@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hersen Wu <hersenxs.wu@amd.com>

[ Upstream commit 5524fa301ba649f8cf00848f91468e0ba7e4f24c ]

[Why & How]
ASSERT if return NULL from kcalloc.

Reviewed-by: Alex Hung <alex.hung@amd.com>
Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Hersen Wu <hersenxs.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link_dpcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dpcd.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dpcd.c
index 5ec6f079b08c4..f3838286c1725 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dpcd.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dpcd.c
@@ -162,6 +162,7 @@ static void dpcd_extend_address_range(
 		*out_address = new_addr_range.start;
 		*out_size = ADDRESS_RANGE_SIZE(new_addr_range.start, new_addr_range.end);
 		*out_data = kcalloc(*out_size, sizeof(**out_data), GFP_KERNEL);
+		ASSERT(*out_data);
 	}
 }
 
-- 
2.53.0



