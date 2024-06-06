Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA25196D8E;
	Thu,  6 Jun 2024 14:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682984; cv=none; b=KklIRCHIGyVpdwt9h48gNYhuaUC9jPoR3ZfMqF6WlmXmxCV44xGpBOvHXVF6hmEcdNP0pWbD1LI4c6mD4N70A8UJx/D5WlAckvpdR1X+6lMx0hHZRjxbX6vk7MxrGMlZaD5EFzg6T0Ymk7ERpzMnA1k0KzKXEOGcCyAHnI8+7AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682984; c=relaxed/simple;
	bh=3enp6nYqIasOnHHHZsVvjq2wWFdT+F2ib/+cwqLV8+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FLrNRaIUtrUn2Q8QDlmBTDHhVl4/2QIEJmF7XV1zTpLUX9HO76wBQHgdzCHRUa3RRxun9KW4ek781I4SQ+y2MRPkvVe6hotiqcDInbqu8WAH9bMPfX4BMQb0DLLTBQNiMzLZmtajO/9dMmM0NFLrb29AF0pVm2nqyFhhAFQdB8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y0oduuME; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y0oduuME"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC7BC2BD10;
	Thu,  6 Jun 2024 14:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682984;
	bh=3enp6nYqIasOnHHHZsVvjq2wWFdT+F2ib/+cwqLV8+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y0oduuME+fEaYxPvbrRgxnin4YKo5ehaRbVEKjXTzgeIBYQKyUA5hW3U/Gd1JWtSI
	 IMLS+CqdfZ9zNWl9llfGIV935QhGa38aK65y4Qn6NdOmiRqvg6RK+4czDYt2FkNZrT
	 ozGqOlWI7sq6OEZA/QZwprxeW+OVahexq9PA05hM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 169/374] um: vector: fix bpfflash parameter evaluation
Date: Thu,  6 Jun 2024 16:02:28 +0200
Message-ID: <20240606131657.556749153@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 584ed2f76ff5fe360d87a04d17b6520c7999e06b ]

With W=1 the build complains about a pointer compared to
zero, clearly the result should've been compared.

Fixes: 9807019a62dc ("um: Loadable BPF "Firmware" for vector drivers")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Tiwei Bie <tiwei.btw@antgroup.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/vector_kern.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/um/drivers/vector_kern.c b/arch/um/drivers/vector_kern.c
index dc2feae789cbb..63e5f108a6b95 100644
--- a/arch/um/drivers/vector_kern.c
+++ b/arch/um/drivers/vector_kern.c
@@ -141,7 +141,7 @@ static bool get_bpf_flash(struct arglist *def)
 
 	if (allow != NULL) {
 		if (kstrtoul(allow, 10, &result) == 0)
-			return (allow > 0);
+			return result > 0;
 	}
 	return false;
 }
-- 
2.43.0



