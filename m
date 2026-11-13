Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590782;
	b=dCVzUJbpfv6O2+UA1YJKEx4C34w1J7++jOnbhRmLy/hnFT94vP6zHss4zBbJkHG83Ti8
	 dUc1fvqJiCXpBCP8bU4HCKJ2nLbaiPXiUkXwPbSpWJ1YiysHDQfHkK7mxtcx4rmPxyltU
	 B8dygc5YqEs7mgCXfsyAvRJrwxGLm5crHGU8V1/YtOiwtn/TtKL9nqG4kA/FKgJujfEl3
	 gYL1EgU0xv0QwKK05/+7OJNhdnPSAcbtYFhQsI6dKFmWVQ5buoiImevzva41nGV/i0L5p
	 Te/kyyVA7QYH15uxpFF6k4mDZAsnxzlTKhDFDsKTxkOLX83F9JOS7uRMTdb6HUqTj9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590782;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=f0uJh7lf2qnVQPFPWTiZdOwyroRV7dOzX7sSmvS1qbo=;
	b=Sml5hFn8f+0mBRezTEC4arODpUrPN7xVjwWA2Kv8u7wUDtnTOltCsg3ckSGXc+NgS+RG
	 0UU6x0aHJ05y12kKxj0j4tVQtkZ2yALPF9KoSRwA0BRHhAfQJ4FutKyaEmrwlOVKKZkD6
	 JJzcRslyw+sXapEPX52E4cgb6mBUMT+EMeQHVdDGHSVbc1yJD0LU8eoEHkBrIASpkiuzX
	 pD2KVu6mbDy87nhu0nX7HAw2zX86qlIzPhYKkzmaKbiLw7MU5ZS5v9rdV0Xkh69z/EAXX
	 LKAXCBF+rN4JFParmo64oldsKJt5SYs61Sb3rtG4y2udOAfOUWouJGaMisp7BniBWWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ytQSvJqw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7979607C379;
	Fri, 13 Nov 2026 17:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ytQSvJqw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 737831F000C6;
	Fri, 13 Nov 2026 17:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590782;
	bh=f0uJh7lf2qnVQPFPWTiZdOwyroRV7dOzX7sSmvS1qbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ytQSvJqw0IMvTk52rsaDyq61hLXdD8seMQvUPWSSO9ZYNBZTpEz9X2XZMm2shg/Hw
	 ABpNqTwPcp8bIBILhtCZsVvWqcGvKYrn7kI1IixiSuMZ6c6UFIMyzXq+mcFF7cmVHx
	 FBQdXTxnSz0+kJ6ZARRDM/5mOfWza4P2uLIhyXwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 676/686] platform/x86/amd/pmf: Add AMDI0112 ACPI ID
Date: Fri, 13 Nov 2026 10:53:29 -0500
Message-ID: <20261113153844.568854564@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 325bcc126cf7a512a0e2da0efddad665f69badac ]

The AMDI0112 ID is used to bind the PMF driver to some platforms.
It doesn't have any Linux side code changes relative to the most
similar AMDI0105.

Cc: stable@vger.kernel.org
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20260826163611.2268377-1-mario.limonciello@amd.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
[ sashal: Adjusted ACPI table context to account for the missing AMDI0109 entry. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmf/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/amd/pmf/core.c b/drivers/platform/x86/amd/pmf/core.c
index e787480f4df26..c1b369fdf801e 100644
--- a/drivers/platform/x86/amd/pmf/core.c
+++ b/drivers/platform/x86/amd/pmf/core.c
@@ -464,6 +464,7 @@ static const struct acpi_device_id amd_pmf_acpi_ids[] = {
 	{"AMDI0105", 0},
 	{"AMDI0107", 0},
 	{"AMDI0108", 0},
+	{"AMDI0112", 0},
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, amd_pmf_acpi_ids);
-- 
2.53.0



