Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060847;
	b=WojqTjo+5W0o2XiM9XOSI0vgUeJN0DekFWy88umQY8YB4OYwa459nTC5bGFRVv1CUL5w
	 Dnj42uabrCuRvmeKZWY+23+m8p8VKDVkypMg/sJ0PLAx0kO6wNs3f/Ar53EBwqxQgIU+h
	 sjhwjuJ4sqmC8+Yaz4heQ7SQbPaUboO/sqrZCVO1+LgoekDU0lvy2OT8I48BoLD11n+ty
	 ws83P10xPJwlGPTCm6XWz5fZgO8ACphgiSPyGsrEeVM3UJYxxPsJ5hq79MNulR8a12y2M
	 S9PIl3BiuY3kT2vr2lmygH1XIsvK5rJRpbDa65lTjup59D3H1sS2Kk4d7rsAQz574yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060847;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ocEAMYaHYeX4+EudoR3s9ajgEKI27kUAaqLXvYobiJA=;
	b=AnAP4mDJMWBj9WZaN16b1U2EhB3a6UbXNClWs3KEEuSJAk/h1o23Tuy858UPL6lpQyWr
	 G5idCiR9Yp06uRUxZWX7Dph2JLSmDZbThVfvBfyWf5YjbfJ3BGFuAo0/0qSatA8BJUJ5w
	 xIz+ibwiPWD3hEDFCmjqu+dGG5rRB1nnLxTc2lpEcoBQyn9Ad3iXNvbwtL7Db/5/6k25T
	 8Whopks1QYd2BUOx+9Ah3bkqrCDPTYZm9eBBwuEhCzCoAvJnxHgzu5a7QnF8FxkfGQycc
	 w/I4Wg3d91YupNLbFrQXnZY/xjf96VvVeFQg+53Q0IGJOGM8WHXFyetikwQHtHZNs7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H1CHxwXu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD08606A330;
	Sat,  7 Nov 2026 14:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H1CHxwXu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCC041F0089F;
	Sat,  7 Nov 2026 14:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060847;
	bh=ocEAMYaHYeX4+EudoR3s9ajgEKI27kUAaqLXvYobiJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H1CHxwXu8PgmKXiDY2YlQ4Z5sR7jWuNKkVt9v+eWB9pRpltd2qaX4LMIvs/YWb+z3
	 RIbk2rMDdqgEVjcSuVXwjmpmxQB0wkWAqq8i9tcIQ9Fb3Q91p+KbNEI5vYGB3Miymf
	 iSA6UB1Lt382IL3zW4zYKeyjfzhIMbYtYyY8t5Pc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0208/1536] platform/x86: int1092: Fix info leak in parse_package()
Date: Sat,  7 Nov 2026 08:37:04 -0500
Message-ID: <20261107135003.503458316@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

[ Upstream commit f5eb833730c071b68a68de5d1df442aae4ae7e6e ]

Sashiko reports a possible information leak that can occur as follows:

1. In parse_package(), memory allocated for data->device_mode_info is not
   zerozed initially as it is allocated with devm_kmalloc_array().

2. In the for loop after the allocation, a malformed ACPI package
   provided by firmware can cause some fields in data->device_mode_info
   to remain uninitialized.

3. Later in update_sar_data(), the uninitialized fields gets copied to
   the fields of context->sar_data, which can be exposed to userspace
   through sysfs attribute read (intc_data_show()).

Fix the leak by switching to use devm_kcalloc() for allocation.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260710052806.100107-1-nihaal%40cse.iitm.ac.in
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Link: https://patch.msgid.link/20260723-platx86-v4-2-93b4a178b595@cse.iitm.ac.in
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/int1092/intel_sar.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/intel/int1092/intel_sar.c b/drivers/platform/x86/intel/int1092/intel_sar.c
index 1cfb268f6b71f..6795b97460c99 100644
--- a/drivers/platform/x86/intel/int1092/intel_sar.c
+++ b/drivers/platform/x86/intel/int1092/intel_sar.c
@@ -91,10 +91,10 @@ static acpi_status parse_package(struct wwan_sar_context *context, union acpi_ob
 	    item->package.count <= data->total_dev_mode)
 		return AE_ERROR;
 
-	data->device_mode_info = devm_kmalloc_array(&context->sar_device->dev,
-						    data->total_dev_mode,
-						    sizeof(*data->device_mode_info),
-						    GFP_KERNEL);
+	data->device_mode_info = devm_kcalloc(&context->sar_device->dev,
+					      data->total_dev_mode,
+					      sizeof(*data->device_mode_info),
+					      GFP_KERNEL);
 	if (!data->device_mode_info)
 		return AE_ERROR;
 
-- 
2.53.0



