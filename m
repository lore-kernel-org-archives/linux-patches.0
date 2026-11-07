Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062142;
	b=eihdFALhPWB0ZwSegRy4NzJZdNmHIVA3j3BCw+ZDStvClHI+xa3vWnYKNY/sojy7rJaQ
	 T7ibniHoa7NagXXqpLfnXFWkREWn1wtBGEpL3kfoXWPO9YF7oHlvuf1QCrE9zs2KYWOcN
	 Ob31m6Io6wBTpSr4BqlEvC9n4mQcQn5nt4tX939W9jEgZd41fZOzKfEXj1riMirkNKO3G
	 PdqC2UC7xjLt+8I61Vap7BcKqrg+CLQsf/qOiQxnn1+uAEKd6R3JURL2h9Y5CECAxZlQZ
	 02RnDP9TLlssj2+Vu1p98ipLxeNGF2S9H7yeBj4udMgEkQwGNNCxMSL3eH6YDk7QqTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062142;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9JC4rS/dBY+nugXim1BdkDSoiZYzRGVOMRZDXbuErRc=;
	b=B52f0IuVUUqH64Pq7iqOCO9LigabF8U8Bj7icGaK/pGjTpHBwcFshNt189R5OlU/1B3V
	 wSp6rdwojXaSQ1ZZ6f7vZZgPXOZITF9djRkEd5H7MxX6AYyDp6hNPzDhRkxB/oYZH8w6t
	 yHJOqOxVh1rhgWvYQxMxzdHlepezhT96Td1Sg6WjM+G7Hk9ZXUlbzYY1gM8irgHV+Lgfl
	 YaK13CFKuX+qBY0JqJ2OSxtGpjj0RkZ8jTfm3Mou+ltTT3+DAXYvUTdODiDtAmTgWXa0/
	 DwpeJsk2w8FcnJRMJV6zEZ7AW0lDaMSwk8mY79irMQBZ4m34xnG1kaU/Dk7+hihIxlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B4v0gZnR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8B6606A653;
	Sat,  7 Nov 2026 14:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B4v0gZnR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB7CB1F008A1;
	Sat,  7 Nov 2026 14:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062142;
	bh=9JC4rS/dBY+nugXim1BdkDSoiZYzRGVOMRZDXbuErRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B4v0gZnR0Kuho1FYmTpA9ofBnLNPWHD/8TFT12qtdnI6P/YYm9VG/ld+ilhfdKx8s
	 RD3QGyAfMGh6gs1AYTJZNXW4u6hi+fYOVBmwZ0XiKyod0azysWkwgnlEeegmJfcIyW
	 8R8uHO7S/Fz537kVV1Qqfi7U8cw/YZ7nKmMKtx5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srish Srinivasan <ssrish@linux.ibm.com>,
	R Nageswara Sastry <rnsastry@linux.ibm.com>,
	Nayna Jain <nayna@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1107/1536] pseries/plpks: clear sensitive PLPKS buffers
Date: Sat,  7 Nov 2026 08:52:03 -0500
Message-ID: <20261107135028.794707756@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srish Srinivasan <ssrish@linux.ibm.com>

[ Upstream commit fe18716ff314eb32299048fd64242d31b4e852cf ]

PLPKS read, remove, and write operations use authentication buffers that
contain passwords. The read output buffer may also contain sensitive data.
Freeing these buffers with kfree(), without wiping the contents, can leave
sensitive data in memory.

Use kfree_sensitive() to wipe the buffers when freeing them.

Fixes: 2454a7af0f2a ("powerpc/pseries: define driver for Platform KeyStore")
Cc: stable@vger.kernel.org # 6.0
Signed-off-by: Srish Srinivasan <ssrish@linux.ibm.com>
Tested-by: R Nageswara Sastry <rnsastry@linux.ibm.com>
Reviewed-by: Nayna Jain <nayna@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260923182816.151451-5-ssrish@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/plpks.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/plpks.c b/arch/powerpc/platforms/pseries/plpks.c
index 3686d66277262..dbfbf12bda3c0 100644
--- a/arch/powerpc/platforms/pseries/plpks.c
+++ b/arch/powerpc/platforms/pseries/plpks.c
@@ -518,7 +518,7 @@ int plpks_write_var(struct plpks_var var)
 	rc = pseries_status_to_err(rc);
 	kfree(label);
 out:
-	kfree(auth);
+	kfree_sensitive(auth);
 
 	return rc;
 }
@@ -552,7 +552,7 @@ int plpks_remove_var(char *component, u8 varos, struct plpks_var_name vname)
 	rc = pseries_status_to_err(rc);
 	kfree(label);
 out:
-	kfree(auth);
+	kfree_sensitive(auth);
 
 	return rc;
 }
@@ -615,11 +615,11 @@ static int plpks_read_var(u8 consumer, struct plpks_var *var)
 out_copy_policy:
 	var->policy = retbuf[1];
 out_free_output:
-	kfree(output);
+	kfree_sensitive(output);
 out_free_label:
 	kfree(label);
 out_free_auth:
-	kfree(auth);
+	kfree_sensitive(auth);
 
 	return rc;
 }
-- 
2.53.0



