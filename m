Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E48017C225;
	Mon, 10 Mar 2025 17:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627084; cv=none; b=O0ONj7LLZwn7PQdg1XSbr0WZ/dF6Ch3cqwfaJPsIvc8ebnKL0dMcwl8DtpOUlaK1v20dCCfhV4C3gEP6udgvYfW6/PQaSoBb3/HPXriAntioYsjtenkp8vwc4ngOAHIYY/pt1+u8BAEKOUwkyt1d/S3MX4wgfOWSpnP02mqUjLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627084; c=relaxed/simple;
	bh=J2RWL60gbpUklli1LjNU+hTbjMuSTGXqCevg+ZLv/1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cfRPs/U5zFCU7KRzHHLnRYmNMlyMw8k9Hspea0jiVfFEoQDO0tJMQrpsJu4zjto+xjQh3O7L74a/DxjxK52ug3TQVoAjAl+iNvNd9HaUxgXyN/Z6OisEN1PIUAOrJbZXtnjEnI5nS/qFZ57D8Cz0izom6zryLRrPakyPiLk5SFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z5Z43X6R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z5Z43X6R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E4BBC4CEED;
	Mon, 10 Mar 2025 17:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627083;
	bh=J2RWL60gbpUklli1LjNU+hTbjMuSTGXqCevg+ZLv/1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z5Z43X6RuchOjIr6RT6xauO2QslRP1kOYiYaIUJEWgWkSfiUW9U/ULW+49zeY9um4
	 ti2itzuFdLMW/qa/oyfgHiFhK6I9vkpK/vO56WaKxiZpjd/V/+d3GOh9gcFV7PlNl1
	 zioA+h5dnBlwV8dWlue0kf6oaZ3mI3oJ4Prs8mRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.13 207/207] nvme-tcp: Fix a C2HTermReq error message
Date: Mon, 10 Mar 2025 18:06:40 +0100
Message-ID: <20250310170456.004222276@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maurizio Lombardi <mlombard@redhat.com>

commit afb41b08c44e5386f2f52fa859010ac4afd2b66f upstream.

In H2CTermReq, a FES with value 0x05 means "R2T Limit Exceeded"; but
in C2HTermReq the same value has a different meaning (Data Transfer Limit
Exceeded).

Fixes: 84e009042d0f ("nvme-tcp: add basic support for the C2HTermReq PDU")
Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/tcp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -788,7 +788,7 @@ static void nvme_tcp_handle_c2h_term(str
 		[NVME_TCP_FES_PDU_SEQ_ERR] = "PDU Sequence Error",
 		[NVME_TCP_FES_HDR_DIGEST_ERR] = "Header Digest Error",
 		[NVME_TCP_FES_DATA_OUT_OF_RANGE] = "Data Transfer Out Of Range",
-		[NVME_TCP_FES_R2T_LIMIT_EXCEEDED] = "R2T Limit Exceeded",
+		[NVME_TCP_FES_DATA_LIMIT_EXCEEDED] = "Data Transfer Limit Exceeded",
 		[NVME_TCP_FES_UNSUPPORTED_PARAM] = "Unsupported Parameter",
 	};
 


