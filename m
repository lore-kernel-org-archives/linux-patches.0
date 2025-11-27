Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE9E3346AE;
	Thu, 27 Nov 2025 15:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255668; cv=none; b=HCoD5PiGUsM9CXwYB/y9K3hZdcLFxm8FVnZTpa5zcxZFFX8t2WBASkldY3yArxL7FefVy1VOV7L2zus9/DFHqgKVHguECrovVW1aOY5Ai6HQnf6aBBataL9UpYOE921Ae9Y+Vi9v4yEqrkkRH6/WiaDtoif8yn5TZ3KTB8wvULc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255668; c=relaxed/simple;
	bh=AdiPP9maNWNFmtMxetzhAIjXJcJQ1oIEHb2cbibTV0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TjvOo8OtIDH8yUXd+Lh3xo9jiigSMiEwp+usOu4kRzky3shXXeIVgS1XpZqFTlFtjuJ9d9c6uvb01JrQ/AksejYAOWSeSCiWbQounx4XRu+cTFICy/oLT17LkodjPzgQ3+DwSul9Q+FolUqiuzJ7MzcGfI5hvwBO7bY6rXkbjhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BUxQm5z6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BUxQm5z6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DCC3C116C6;
	Thu, 27 Nov 2025 15:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255667;
	bh=AdiPP9maNWNFmtMxetzhAIjXJcJQ1oIEHb2cbibTV0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BUxQm5z6vN/rh3zBWk8a1mUYj/hsgUK6U8b76mlSIqQzL+WZUpBjyaVACpjXYzdTY
	 QA4llJiEbAAcqIl1Dw7KF8PKXcLjHka7O5OOiFlf1bich33qq2Wm3ZZMD9pPHr25sx
	 7l3vcn4vhNqved7O+18+SbR7MtcwCY8rPMMowNhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.17 073/175] drm/amd/display: Increase DPCD read retries
Date: Thu, 27 Nov 2025 15:45:26 +0100
Message-ID: <20251127144045.632168286@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello (AMD) <superm1@kernel.org>

commit 8612badc331bcab2068baefa69e1458085ed89e3 upstream.

[Why]
Empirical measurement of some monitors that fail to read EDID while
booting shows that the number of retries with a 30ms delay between
tries is as high as 16.

[How]
Increase number of retries to 20.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4672
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit ad1c59ad7cf74ec06e32fe2c330ac1e957222288)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
@@ -1691,7 +1691,7 @@ static bool retrieve_link_cap(struct dc_
 	union edp_configuration_cap edp_config_cap;
 	union dp_downstream_port_present ds_port = { 0 };
 	enum dc_status status = DC_ERROR_UNEXPECTED;
-	uint32_t read_dpcd_retry_cnt = 3;
+	uint32_t read_dpcd_retry_cnt = 20;
 	int i;
 	struct dp_sink_hw_fw_revision dp_hw_fw_revision;
 	const uint32_t post_oui_delay = 30; // 30ms


