Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212550;
	b=TKy20/gRwR02bf3nSfl9q8/bBvHZfVzUYr1rLIGvOpNS/z0pUQuaBgmPEDMJwnm3CYBS
	 WAITv+gwCDY8Qcrvf9L448u5RMfvhFiHKP4WSLX5ChmnpHHXq1VxtDkB7bLkR+xmlD8HL
	 z6CzUflT6yHo9U3IgbqAlcSCaNm2UZW0Egc4xh7tT3O+9Jz0IIPIuLEE2I0D50JT+YTGa
	 aHu8kOlHSMlQGwkfLfv3o4PSBHFfBwvSc6tz4c5qZnosGs4DE6xcc05bTx2585Wm916bs
	 v4TzYCQtkLph/NiNVyv3MjUNqflJjhvmyElHGMoQaYOA9hdpE+k2zchVOjLhgjrFBwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212550;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kE5OHKHKfSWWZB8HPAKD9fSO6+/TZ9ucaiNBjAo8ORo=;
	b=WO32E6CoELe01gSD2v4WVVy2ehYpwcw7FcI9Ss1uG8axM9ZEiQ9jhzpA52E1qFcnIegw
	 5pPO9ykDzwoaq04Oz7O0A623fJD090/S6bDeG8zV5ksnPyjWU/FJt3vPqZqxD4N0Pf2aK
	 /5tRBZ6rbE87ohuZFbXyKvY0yp+N67f46Ily+tjmlcg4gy2xxteEhqil7EUYP7sLT7iWa
	 PZs5sewr1fiLjvFwtwYF7EPeNvbqZMxK8fAjUl7xG/8KEHwfpHP1DQvA+K8ktkUtkx9/+
	 P8UKE2IUrhYwNXkUmmNuGGQB6KAof1f/Mlq1bODvnmjjBPNt8O6ZWws4imeHZY0hUAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QhscH3vA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1752606A31E;
	Wed, 28 Oct 2026 18:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QhscH3vA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C67F1F01825;
	Wed, 28 Oct 2026 18:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212549;
	bh=kE5OHKHKfSWWZB8HPAKD9fSO6+/TZ9ucaiNBjAo8ORo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QhscH3vAvgrluGW2h/M4iQFQ8p73EOMzfe66tOfyi0eiDkeemyt/CXjZJdn4XtyyH
	 pOwmGDveiHThXPzXHiZAKn+7pEiJbx85vWI+AOOs3X5pSH/0UcePC3/UpDXmDf7hB+
	 nw+Un3RaF+5zgEr3iZc5tGs+JKqFMOVbG1qqldtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Dnyaneshwar Bhadane <dnyaneshwar.bhadane@intel.com>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0192/1887] drm/i915/hdcp: Add encoder check in intel_hdcp_get_capability
Date: Wed, 28 Oct 2026 17:38:08 +0100
Message-ID: <20261028170503.605849244@linuxfoundation.org>
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

From: Suraj Kandpal <suraj.kandpal@intel.com>

[ Upstream commit 31b42af516afa1e184d1a9f9dd4096c54044269a ]

Sometimes during hotplug scenario or suspend/resume scenario encoder is
not always initialized when intel_hdcp_get_capability add
a check to avoid kernel null pointer dereference.

[ Backport to 6.1.y: this tree uses the older intel_hdcp_capable()
  helper name. Apply the same guard there; the code change is otherwise
  unchanged. ]

Signed-off-by: Suraj Kandpal <suraj.kandpal@intel.com>
Reviewed-by: Dnyaneshwar Bhadane <dnyaneshwar.bhadane@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240722064451.3610512-2-suraj.kandpal@intel.com
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_hdcp.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_hdcp.c b/drivers/gpu/drm/i915/display/intel_hdcp.c
index cb7f86de967a8..507721c94f2fd 100644
--- a/drivers/gpu/drm/i915/display/intel_hdcp.c
+++ b/drivers/gpu/drm/i915/display/intel_hdcp.c
@@ -182,11 +182,16 @@ int intel_hdcp_read_valid_bksv(struct intel_digital_port *dig_port,
 /* Is HDCP1.4 capable on Platform and Sink */
 bool intel_hdcp_capable(struct intel_connector *connector)
 {
-	struct intel_digital_port *dig_port = intel_attached_dig_port(connector);
+	struct intel_digital_port *dig_port;
 	const struct intel_hdcp_shim *shim = connector->hdcp.shim;
 	bool capable = false;
 	u8 bksv[5];
 
+	if (!intel_attached_encoder(connector))
+		return capable;
+
+	dig_port = intel_attached_dig_port(connector);
+
 	if (!shim)
 		return capable;
 
-- 
2.53.0



