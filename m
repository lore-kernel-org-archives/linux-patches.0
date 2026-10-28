Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207431;
	b=KhlMTUa+bwobBIs5+GPbj53iKGdObtDNS61AAWH2q0ofSnBqkQJ/G06v2SQYe+qW7N/W
	 nvy0/tuhY0UGqeYq7vzyI3OYcz9/u0qz4ZZzYdv0r9EyujtEZbEUFRCXEZeFkWBBaOSmQ
	 0KngjSnOk2NekWbBnlvJ96DcFCB1BJixYh4EKekYhANXisYwy47mDpU8+bUYM54p8AqQ6
	 rIgPxrx1JAQMfqs8BJQtJvz1VjlkRcqHPYcmXlL6SNUTvoMb0ujYGXB0xX8v+iV4SKQpC
	 8Ji8F/dXMM4IVjxso/2DsDQJnwY07ogE7W8Tuhn576lpAfynvt8TFtgi+0LB3xc/Eeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207431;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dZ/ryqimjdwFFZNbdUy+Sj0jYCia6aok38QBqsFTaOs=;
	b=RQ9mn/tmvrn8eWtHDeta2Tr++VgJ7XKB1uRh7P1yEZ0AQogDjaSF6rOcZSdwurD2qM2e
	 BWIn0TIsYiVMaylqwInQCrgUcbkQOCngHHsvWqHQdVIvi028aTzKYlPntQESGkOb4uqKK
	 0U1G9fXFQAdU6EKeHrqMjbDWR3PVEt5Qj2zm75BqBEBPYizV6jS4nv8lyZ0/tfnyhsb3Q
	 0jxJM70Zxh+Bmsnvy8wZahtvWF6BWOuzAyyly6jQjvRzBUfIngkeSGD0HEUp6mYKyo/0d
	 rDL/1IOezvKG14N56IKONLoSbXyTnxrvL4SdMtLAycUCNgv6y2zl61aqsffKHHuh7FQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DPhGjlT5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 259C4606A31A;
	Wed, 28 Oct 2026 17:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DPhGjlT5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 766E51F01825;
	Wed, 28 Oct 2026 17:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207431;
	bh=dZ/ryqimjdwFFZNbdUy+Sj0jYCia6aok38QBqsFTaOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DPhGjlT5DBLhgCoFNiN8FANn2o05BAFH7BtnY2QWMzI5KCp+2D51ytcDJDn0SeQ0P
	 ObkPFaYWTT//g0tWdtp04DkfNox0oLj50us6y2kOo1CxYz0mnGyTqs4ZUHyE49umug
	 dClhs0cnqUM3qbG5t237GIft2yqopHv43AVD6hvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinhui Guo <guojinhui.liam@bytedance.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 015/247] soc/tegra: fuse: Add missing newline to APBMISC error message
Date: Wed, 28 Oct 2026 17:56:58 +0100
Message-ID: <20261028165947.719027443@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinhui Guo <guojinhui.liam@bytedance.com>

[ Upstream commit 2f4a0fb66d313f03832f061bc3ec25b33c8198c9 ]

The error message printed by tegra_acpi_init_apbmisc() when failing to
get APBMISC memory resources is missing a trailing newline. This can
cause the message to be merged with the following kernel log line, making
the log harder to read.

Add the missing newline to keep the error output properly formatted.

Fixes: 7b0c505eb341 ("soc/tegra: fuse: Add tegra_acpi_init_apbmisc()")
Signed-off-by: Jinhui Guo <guojinhui.liam@bytedance.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/tegra/fuse/tegra-apbmisc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/tegra/fuse/tegra-apbmisc.c b/drivers/soc/tegra/fuse/tegra-apbmisc.c
index e2ca5d55fd312..b506ed40e1080 100644
--- a/drivers/soc/tegra/fuse/tegra-apbmisc.c
+++ b/drivers/soc/tegra/fuse/tegra-apbmisc.c
@@ -277,7 +277,7 @@ void tegra_acpi_init_apbmisc(void)
 
 	ret = acpi_dev_get_memory_resources(adev, &resource_list);
 	if (ret < 0) {
-		pr_err("failed to get APBMISC memory resources");
+		pr_err("failed to get APBMISC memory resources\n");
 		goto out_put_acpi_dev;
 	}
 
-- 
2.53.0



