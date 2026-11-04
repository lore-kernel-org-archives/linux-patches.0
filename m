Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831587;
	b=PbwCFqioolbQ9HLhbpn+tfVZ/0YKuh66dmpMG5er8xCmQWDcWu70dXdx0pTVG7Ry2s78
	 NDnAaVhF0p9AvT878X9UveXgivQcAQoh6/LQwBjC7bYywHVhE051cmwRsaPAzxyKyi9xM
	 MdRsWt0KSZWVOvQCiTSrP7/VTrN5VpGt3O25y7F6Q/gA9oqk08nI3ZJsyeey3mgEw20Rb
	 cEcjbeccqJFocxMYVZYWCrLII9EA3ZiBaFcMzFqiblmaAOE1l5oGVtfFByGcA76hFkRcD
	 tvNX0E7/kgUYJTDZg6vgs+aqNoZJmRYk8FwFolSV8hFTfA7qmUv7b+6BQpn06CmYwEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831587;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ljno2hkKRkzZiWueD/K6l2QRwaJmeGiSIPsrCKXd8eQ=;
	b=ib44c6jN71VhnQMX1q1pU/loxYCPwJ9k67R07FO1hl32BjAWXb41ad5o5Bz4KWDL3wSs
	 TN2t6hzweZ7LXPv1eFJZvqKjDYvSLfCT6TxfmM4w5BMyDE3OzPHGHMNjuOIcC5dq40EeM
	 LzbfeLaT+ECMc8Db60vcvubOpUsCi27040CvkvAX/dB1tWly9inMQ9KSTP1NYaXIZa/NT
	 LStAZLmXFyh1yR0+VrFVhKP0FOJ2c5CBSxrLXgsq1kednL0mxm7Rxqj++q1dPHbQc1EuB
	 r53L8txXgOGAnMZEPE7IGRx0ntnGo8a49iHuWfRMKBv0T0Ht2OR+MK7s9cJJEIJ3SUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2n2u8A3O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1080E606A84D;
	Wed,  4 Nov 2026 22:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2n2u8A3O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CCBD1F00919;
	Wed,  4 Nov 2026 22:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831586;
	bh=Ljno2hkKRkzZiWueD/K6l2QRwaJmeGiSIPsrCKXd8eQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2n2u8A3OdLceYI8TxlyMRdOXCeh+5Vh0YVfw1hfzEU5WyC3txOI0Fx3w3+Otv+qGZ
	 GNMHso/oyEFrcltyw28F8o3wLug6+1W11xszyJxl2Yp+32I4d1WcKXi7XLFCSkfLn/
	 9aFgedrLFe0j0umv8KmW5QtwEhgdhwHBjslC5M8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Sandeen <sandeen@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0792/1005] xfs: validate rc_domain in xchk_rtrefcount_mergeable
Date: Wed,  4 Nov 2026 16:08:45 -0500
Message-ID: <20261104211105.526410542@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Sandeen <sandeen@redhat.com>

commit f04361fb8694bff98ec61e2e2030a1993426fdca upstream.

xchk_refcount_mergeable validates that the domains match, but this
was omitted from the realtime version of the check; fix it.

Fixes: c27929670de144 ("xfs: scrub the realtime refcount btree")
Cc: stable@vger.kernel.org # v6.14
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/rtrefcount.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/xfs/scrub/rtrefcount.c
+++ b/fs/xfs/scrub/rtrefcount.c
@@ -380,6 +380,8 @@ xchk_rtrefcount_mergeable(
 	if (r1->rc_blockcount == 0)
 		return false;
 
+	if (r1->rc_domain != r2->rc_domain)
+		return false;
 	if (r1->rc_startblock + r1->rc_blockcount != r2->rc_startblock)
 		return false;
 	if (r1->rc_refcount != r2->rc_refcount)


