Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619934;
	b=4mWvE3Xm4MZlMqMtcNUlZnb8eX3OuLurH7ItOJPVjBCUN1jNoS8+hRzdRs+bf60/nzE2
	 sKybpnBihSrRgoHW1Ign7AAVHPbA1EZ+z4Ynsa3s6h16pXaaebiVm2+Uat5+I2TsBrumN
	 zfjiTBi2TKChy2Z53o82/JSDIyEVXyBXstOqSdssFAsT11DlAbtkZm7wa+m7Qy/qKDutu
	 s/RhL1WqLxkWFkhIA+0aBOkZmZO8Efk+smXAh0yEAqiFsDop66GrOCytBIukqKlk8sQUM
	 c65DU3TzHtuiUGc6+frusI3LYN2bt5QyUdajDa4M6LNF7qIQ8dH/jFETgrHkWqboCCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619934;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=K13I0Qjak81HuDhayJBQ2Paqh+QOFJJ2MG4ttEXWHqw=;
	b=wDjr6WhrOE9ivT0+svLx22qm5+d7VAc43W7dRczzTGR7ATAsHOjKYYcft/Q/bvHhdrVm
	 l9ojyFcCjaUsko1mHoeVJII+ubznTlnbR9Y7NBap7tZ4pqdySROe7hGC4JH1wXBAy3tkQ
	 i/V+dJ3lMFPZWL8krS56ZoANiUhnGBO5i8bS/WGAnQTiM2DD8a7UTEwvZRB8J+mXFlVrn
	 eTWWN3j/EgfihAhnRSRyq67dS/RwYy3CG6Y+8wt8rB8RFLkrGZWnXkLEqDh7F1FYcOxZ1
	 LEfhl5ACTza5lIPwQ3xVSpKZyg5YtuGZU3NGj9uI6T5nEdvwwtJeoIE1thpeRWZ4/rQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="dxU/7t0h";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74268606A323;
	Wed, 25 Nov 2026 15:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dxU/7t0h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C65381F000C6;
	Wed, 25 Nov 2026 15:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619934;
	bh=K13I0Qjak81HuDhayJBQ2Paqh+QOFJJ2MG4ttEXWHqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dxU/7t0hHYNzdQFro8Dx59dDK4+GACwUo1qpV0L8hDjMTE/oT/TtG72q7b7kX9xtg
	 8+g9mNSJ98Zf5Ayi8yCQXk7okV4MU4Fm8/fGOnzF4bXe0Wt5m4Fv6LLGSyea7mNEVy
	 bfrLlY1NbIDp9swfxYKdcSYd6E2zh9L14ijALpKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	=?UTF-8?q?Jan=20H=C3=B6ppner?= <hoeppner@linux.ibm.com>,
	Stefan Haberland <sth@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.3 0755/1005] s390/dasd: Fix wrong free and refcount leak in build_check_tcw error path
Date: Wed, 25 Nov 2026 15:34:53 +0100
Message-ID: <20261125143839.431666495@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Haberland <sth@linux.ibm.com>

commit df56f7a6c20a5eb2794c0a7391bde50ba7c8c54b upstream.

dasd_eckd_build_check_tcw() allocates its request with
dasd_fmalloc_request(), but its out_err path frees it with
dasd_sfree_request(). The latter uses a different pool and therefor,
leading to invalid pointer arithmetic and a crash.
Use the matching dasd_ffree_request() instead.

The same error path also leaves start_priv->count incremented
without ever decrementing it again.
This leaks a permanent reference on every build failure.
Decrement it before freeing the request.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260722103704.1709668-1-sth@linux.ibm.com
Fixes: 8fd575200db5 ("s390/dasd: Add new ioctl BIODASDCHECKFMT")
Cc: stable@vger.kernel.org #4.7
Reviewed-by: Jan Höppner <hoeppner@linux.ibm.com>
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Fixes: 5e2b17e712cf ("s390/dasd: Add dynamic formatting support for ESE volumes")
Link: https://patch.msgid.link/20261112102608.1057852-4-sth@linux.ibm.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/block/dasd_eckd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -2780,7 +2780,8 @@ dasd_eckd_build_check_tcw(struct dasd_de
 	return cqr;
 
 out_err:
-	dasd_sfree_request(cqr, startdev);
+	start_priv->count--;
+	dasd_ffree_request(cqr, startdev);
 
 	return ERR_PTR(rc);
 }


