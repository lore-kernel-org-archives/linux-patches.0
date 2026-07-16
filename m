Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0CA22FFDEA;
	Thu, 16 Jul 2026 13:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210023; cv=none; b=NDsTTXmQJII6WK5AxFDomtbH7X6vSUV9UE8YVhzC4NHoqTkJrW1ovNL8yqQeZCRKznycpU+VAVyVfvXt91AyhWC1SDqYN18pOqtSGD2t/4eHtC3tWYK6Joa4RiVLJFkfU/p9Va2446hNrEQ3ltSry4yjkULfGhGdzuEpff1hXhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210023; c=relaxed/simple;
	bh=GEkmYicLDIHFKV1+K80mygTpvGLNlVqB9AwTKxPfMRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ws/NXZjei3P/ug+yvLMrA8eOILJL505sNamxxJkrnguclDHnP364QGiPgTo8a3FnnYbvip5L8OlCnnQOAwRmXQpQa7h6Zn65KQxIuP6nCMwNwAGXtipMh4nyscklfzpQEyILtWM7kv2+5pTHbD5xcpN3ho1Dq3aBSmV8RDBmqfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dMEn26+k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dMEn26+k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 133B21F000E9;
	Thu, 16 Jul 2026 13:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210022;
	bh=4YQrXMSgMoF9Wa2D1TzNjBKfypzq2XnF9iAQv33YRYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dMEn26+klQqsSqyVjqU8Js8yFYCG9isorp8dVV6tVr3WLw4De7w2YS4g00BVHONJH
	 rk+vnFae9oEZmqKDVVJqxYkczfA1JoFZOfhdKoh+/L/pTykukSi8ZJzbiES58loh2Y
	 6hNIrBYEmes+ffmcDY7H+HQkTOHLxsZuZCL0XLFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Boccassi <luca.boccassi@gmail.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH 7.1 409/518] liveupdate: reject LIVEUPDATE_IOCTL_CREATE_SESSION with invalid name length
Date: Thu, 16 Jul 2026 15:31:17 +0200
Message-ID: <20260716133056.783140568@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Boccassi <luca.boccassi@gmail.com>

commit e947433cd0d2b95a277757451b9b9c2714136dc2 upstream.

A session name must not be an empty string, and must not exceed the
maximum size define in the uapi header, including null termination.

Fixes: 0153094d03df ("liveupdate: luo_session: add sessions support")
Cc: stable@vger.kernel.org

Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Link: https://lore.kernel.org/r/20260429212221.814107-2-luca.boccassi@gmail.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/liveupdate/luo_session.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -382,9 +382,13 @@ static int luo_session_getfile(struct lu
 
 int luo_session_create(const char *name, struct file **filep)
 {
+	size_t len = strnlen(name, LIVEUPDATE_SESSION_NAME_LENGTH);
 	struct luo_session *session;
 	int err;
 
+	if (len == 0 || len > LIVEUPDATE_SESSION_NAME_LENGTH - 1)
+		return -EINVAL;
+
 	session = luo_session_alloc(name);
 	if (IS_ERR(session))
 		return PTR_ERR(session);


