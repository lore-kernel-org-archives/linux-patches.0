Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0B428B4F4;
	Wed, 23 Apr 2025 15:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421845; cv=none; b=ff+62wd+fefCPBZ4U68dM/1pTnbdwlxB4CUuDjx+I0zLzDte0DQStg9NVJ0Rb9ITBXL0TMnBw8XQOF32C+TN67h1XD2dTMyKY5kGUJV4rIP0GZ3lJoeEyGAyRrSg410mDN4rjE+R1WDnTKcR19Selxgtv/gb30KfBKuGWiWBNaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421845; c=relaxed/simple;
	bh=Q4nfhE3pZiU60b694QZFae1dGZPlCIJHkvhJBHUCedE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tIjhvnceCnHWhQ2prCma6AaUOFItNRU6Ar6Y1QN0ZhNQ4QUBAQAqLn0olX59gNBRcUnjmv5F/3xw+V3d7qIPhg41f5pWCVo7TJuczEkbYaRd/k8ordpETKKWxe7ovL9WM/wMmEm4UL437fAdUwS4Sb8RV2LKU78dlw+tszFMcWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iOTyvRVW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iOTyvRVW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74487C4CEE2;
	Wed, 23 Apr 2025 15:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421844;
	bh=Q4nfhE3pZiU60b694QZFae1dGZPlCIJHkvhJBHUCedE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iOTyvRVWYqqA63iA/lKdkUkjsUJQeuvIArZdsvvTtKsT8NXoUTFNxgR0grl7Z4kC4
	 g1pW/NQ1cil/HK8dKGVQEO8mYhGpYbF1zFlUxawLsUjQjqph8U1xbxU58tg0krANxg
	 wv1JsAFCqrx9wkL0KOeu8LpiYcogRtP7CjzQbQlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Liu <liucong2@kylinos.cn>,
	Geliang Tang <tanggeliang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 230/393] selftests: mptcp: close fd_in before returning in main_loop
Date: Wed, 23 Apr 2025 16:42:06 +0200
Message-ID: <20250423142652.891545407@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geliang Tang <tanggeliang@kylinos.cn>

commit c183165f87a486d5879f782c05a23c179c3794ab upstream.

The file descriptor 'fd_in' is opened when cfg_input is configured, but
not closed in main_loop(), this patch fixes it.

Fixes: 05be5e273c84 ("selftests: mptcp: add disconnect tests")
Cc: stable@vger.kernel.org
Co-developed-by: Cong Liu <liucong2@kylinos.cn>
Signed-off-by: Cong Liu <liucong2@kylinos.cn>
Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250328-net-mptcp-misc-fixes-6-15-v1-3-34161a482a7f@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_connect.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_connect.c
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.c
@@ -1299,7 +1299,7 @@ again:
 
 	ret = copyfd_io(fd_in, fd, 1, 0, &winfo);
 	if (ret)
-		return ret;
+		goto out;
 
 	if (cfg_truncate > 0) {
 		shutdown(fd, SHUT_WR);
@@ -1320,7 +1320,10 @@ again:
 		close(fd);
 	}
 
-	return 0;
+out:
+	if (cfg_input)
+		close(fd_in);
+	return ret;
 }
 
 int parse_proto(const char *proto)


