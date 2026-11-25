Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620697;
	b=A2EMOzbYwrYR5AbrzN8tn7i6BXwLLgwR+Mh4P+Zl2gQxil+XQt2IYFKeWETj2V+l+w7/
	 GxmqWCjlM2jjkpJlyMIH9DQMGKD2DhHpoArEL9V5mCfwMD1+bWD6oXoAY6WIyLDAyMjjy
	 ZWVdjTb1A6fMBVNFdKYEGPDv8/mgTcVCcOmJiTd48BwIKkFTa4Ug/vufFFJlHSYvZYWxq
	 t4duKrUrkVEZwbm7g+UZ6esTk7+FHB07+dpYvW8v/TErZWoiGzQ7y7aFIJtB0Wmiy1Yev
	 Sa6f8eGye30w8rk/HvM7yP3kAH9eo4QwzcFyWdhiERP7c5AxV/9rBa7CZP69rYGBgGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620697;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YQhZsqjhLM7m4lVmO1BnObalQoqbNQujDLlHxnM447A=;
	b=mFezb+b2aMXTpBAvalTQDS7eUDhOborFN2XVf3jcn/U0GQ8Kvv29Z1MbXbSKBWqMG7Yh
	 PyNNdsvIvnCr1UnXkDxsH86MwOW9HcKnxkTwc3MPWOG59+TkmWe1zx3h2PQGa5+9I9Np+
	 PFE1LIZjmP1YDIfCHEoPpggv33SS+8/iCCWG2PSwTaRx7VM0V53ZysYXNQX0pYbLzct5g
	 UulekfdK92l88gzPoAA8M0lIT2xoQU7WcAM0h1ptNo2iCezJgS/ZhTVUoG3C1wyK1rAEE
	 2dApsdAiCctr/epvXUONu4+EzrofvuHHIuT/L06L8pZ/YksWDZIwJbRVSrknkoxaTrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ks5Nj8rO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C0A606A321;
	Wed, 25 Nov 2026 15:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ks5Nj8rO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 121D51F000CA;
	Wed, 25 Nov 2026 15:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620697;
	bh=YQhZsqjhLM7m4lVmO1BnObalQoqbNQujDLlHxnM447A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ks5Nj8rOwNlmG0PQuLPm7JSSW6M7+JKxfAsLU7oVhBlhzrFJqcpM5Uvcn1ztMXEai
	 TAH4WTwyvbv+IvEDdUeqKwcflj7nTiiE1FprUokkqmG/H830ZeNa/5aRUcJ9Hm1s3G
	 Xc6c1ORxdZYaEvFO4917NIrONEQh4ptFTogNGEA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Lin <Wayne.Lin@amd.com>,
	Thomas Lamprecht <t.lamprecht@proxmox.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.3 1003/1005] drm/amd/display: Dont warn about links without an HPD GPIO
Date: Wed, 25 Nov 2026 15:39:01 +0100
Message-ID: <20261125143845.147030535@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Lamprecht <t.lamprecht@proxmox.com>

commit fb3d0ee0f7cf41488aff58c45f1b31a8f54f3372 upstream.

Since commit def3488eb0fd ("drm/amd/display: refactor HPD to increase
flexibility"), the link encoder programs the HPD filter, and
dce110_program_hpd_filter() and dcn10_program_hpd_filter() hit ASSERT(0)
if the encoder has no HPD GPIO. That is the case if link_get_hpd_gpio()
finds no usable HPD info for the connector in the VBIOS, where
program_hpd_filter() used to return early without a warning.

This logs a warning with a stack trace on every boot of some systems,
for example with Ryzen 7 PRO 4750G APUs on ASRock Rack X570D4U and
X470D4U2-2T boards:

  WARNING: drivers/gpu/drm/amd/amdgpu/../display/dc/dio/dcn10/dcn10_link_encoder.c:1514 at dcn10_program_hpd_filter+0x39/0x90 [amdgpu], CPU#7: (udev-worker)/836
  Call Trace:
   program_hpd_filter+0x5d/0xb0 [amdgpu]
   construct_phy+0x96f/0xe60 [amdgpu]
   link_create+0x1f0/0x240 [amdgpu]
   create_links+0x164/0x4f0 [amdgpu]
   dc_create+0x3ba/0x720 [amdgpu]
   amdgpu_dm_init+0x2c9/0x420 [amdgpu]

Return false without asserting if there is no HPD GPIO, as before, and
keep the assertion for failing to lock the pin.

Fixes: def3488eb0fd ("drm/amd/display: refactor HPD to increase flexibility")
Link: https://forum.proxmox.com/threads/kernel-7-0-14-24-and-7-0-14-25-bug-in-amdgpu.187181/
Reviewed-by: Wayne Lin <Wayne.Lin@amd.com>
Signed-off-by: Thomas Lamprecht <t.lamprecht@proxmox.com>
Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 62ea146c23e14f958744507c37025f1a7f9c041b)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c         |    5 ++++-
 drivers/gpu/drm/amd/display/dc/dio/dcn10/dcn10_link_encoder.c |    5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c
@@ -1841,8 +1841,11 @@ bool dce110_get_hpd_state(struct link_en
 
 bool dce110_program_hpd_filter(struct link_encoder *enc, int delay_on_connect_in_ms, int delay_on_disconnect_in_ms)
 {
+	if (!enc->hpd_gpio)
+		return false;
+
 	/* Setup HPD filtering */
-	if (enc->hpd_gpio && dal_gpio_lock_pin(enc->hpd_gpio) == GPIO_RESULT_OK) {
+	if (dal_gpio_lock_pin(enc->hpd_gpio) == GPIO_RESULT_OK) {
 		struct gpio_hpd_config config;
 
 		config.delay_on_connect = delay_on_connect_in_ms;
--- a/drivers/gpu/drm/amd/display/dc/dio/dcn10/dcn10_link_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/dio/dcn10/dcn10_link_encoder.c
@@ -1502,8 +1502,11 @@ bool dcn10_get_hpd_state(struct link_enc
 
 bool dcn10_program_hpd_filter(struct link_encoder *enc, int delay_on_connect_in_ms, int delay_on_disconnect_in_ms)
 {
+	if (!enc->hpd_gpio)
+		return false;
+
 	/* Setup HPD filtering */
-	if (enc->hpd_gpio && dal_gpio_lock_pin(enc->hpd_gpio) == GPIO_RESULT_OK) {
+	if (dal_gpio_lock_pin(enc->hpd_gpio) == GPIO_RESULT_OK) {
 		struct gpio_hpd_config config;
 
 		config.delay_on_connect = delay_on_connect_in_ms;


