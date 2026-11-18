Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036328;
	b=gyGpUyjrLM/JxiqlR8OsIxkCdlQHewlOilEo1uxIvgOCohHP5xPFITNKKIOXMeR4HRW6
	 AU7afr1DvDUJpWPN2cC+IU0mjhB6QA+jfLkHgRcE89UUJ6OPUWyDLcuyqt98k0By9bAfj
	 MZTo5674ypkRfwlG81ZaFjo6sIbU+aFBKUx3WkSfYnVt54Csuz+8MX31b6hV5uUkBTn27
	 sKPnmoXDgkxpDg7sNm9uJ/0qb+Nc77Su1nuCdRs5IrkqpUcCZtN3qm0WPRCag/uPzV+PZ
	 wkGd/Qlz91t6LZct202Vr17nNv248mjQGvRith5+BJ3fjlzo9nvizbjYhnOT+SVV2xA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036328;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3C6uIF1DzSc2uPYDoGp9PThQl4sbfvpKqiO6xa8AKlQ=;
	b=DDma6kY5JLa+D+S6qaYlVmVq8u7qy26x+XNsAerUNEYxMda9G7NzKHpqJDpbyg6gVJP5
	 Bf2L6Sk4VqiwumaRdMkhIlEMBrL0hsKP8hto5dMrS+Okdmfd+zwmi1l54I/ZLjqO8IFAR
	 +IWXEWG/ys7xILYi9VVfZW2LwDkPlLqIPJmYu6Ffyz1//IDOK7CWEuVuVm97AAysKng4q
	 181rMO/m+u8Tac6HDpm9cHyGKNMuI/KM6XhuRUj2iG+iU87e4sDXxTq6tPa6cCNpc9bPo
	 8IRBfiSn0akOflC/Twhr9wjsEhPtdolArQCGcmKLF7FqWUw/Kxv5iJ8xXK6mdBy2nKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D1LEOcwa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34BC606A331;
	Wed, 18 Nov 2026 21:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D1LEOcwa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFF2E1F000C4;
	Wed, 18 Nov 2026 21:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036328;
	bh=3C6uIF1DzSc2uPYDoGp9PThQl4sbfvpKqiO6xa8AKlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D1LEOcwacxUy7mfIgTbduD3nkA6ghce79FlOPpQc1U3woi4nW8xcIHOQhc5IenpL+
	 gU2Susmfs5lXJqT/KwV3Pt2GQLNzFjhmKHgqVRYS2/C9wBtoLRuQDXs+1e06JgCl6x
	 6rk5zqJW33wcIxqPJAkgMOjok17Sl3NmeoGE2LUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srish Srinivasan <ssrish@linux.ibm.com>,
	R Nageswara Sastry <rnsastry@linux.ibm.com>,
	Nayna Jain <nayna@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0967/3318] pseries/plpks: clear sensitive PLPKS buffers
Date: Wed, 18 Nov 2026 15:26:29 +0100
Message-ID: <20261118150348.681429229@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 52a3638b35ff8..d6a1e47c1677d 100644
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



