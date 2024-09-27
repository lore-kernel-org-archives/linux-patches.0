Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF4C1865ED;
	Fri, 27 Sep 2024 12:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440125; cv=none; b=A+0eSZCkirqDINNk5eTQcbMUbOKrLuOHyE6qauNRacSztIYDAAXaRVhbiyuZQ9DInP6LuwxXI0I7eZukplE8etHFYTjmyctML6EE2O+Re+6uW3ljromflQu53h3gbF9035K/ANLOYcEwPVXji/6GDNp9ETvvldu7s5gloIxZ5L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440125; c=relaxed/simple;
	bh=cKAeM39MKKWNH9a19xM+mwpLy6eaB7MPJ52naojCo8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MDp9PyT5mR9dxcIOlkGfBcl9hataSFtbH1O3J1Sc8YF7Kk2xMrhz35mC447/iUorwLFcDz5JYHWLUEmBi9EyqdO+T5rEx3c3sOiJU1hM5V/UTRmRoq3/cjc0ZGIs52V9sgH3JQVD6axfKcHE2AZqqXeAQ9VlXmMQXcZ5UpiORqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lYAVw7le; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lYAVw7le"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A0ADC4CEC4;
	Fri, 27 Sep 2024 12:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440125;
	bh=cKAeM39MKKWNH9a19xM+mwpLy6eaB7MPJ52naojCo8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lYAVw7leatxM8AG4xJrEbp944LwVKWW163sX5c3CuVgWghK9uLDYoffz0FnbOEsyr
	 TKcSs5nHdJIPd+KV3lijyD8hjiqkuJYBrMmf31bjjqrMkV5UuD60I5gUZS8LgPX35N
	 Q8XbZ5hKTOfHQ/Rzcz1JYCoV4H1AYGCkgUYibpmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhang jiao <zhangjiao2@cmss.chinamobile.com>,
	Saurabh Sengar <ssengar@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 41/58] tools: hv: rm .*.cmd when make clean
Date: Fri, 27 Sep 2024 14:23:43 +0200
Message-ID: <20240927121720.425964615@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121718.789211866@linuxfoundation.org>
References: <20240927121718.789211866@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: zhang jiao <zhangjiao2@cmss.chinamobile.com>

[ Upstream commit 5e5cc1eb65256e6017e3deec04f9806f2f317853 ]

rm .*.cmd when make clean

Signed-off-by: zhang jiao <zhangjiao2@cmss.chinamobile.com>
Reviewed-by: Saurabh Sengar <ssengar@linux.microsoft.com>
Link: https://lore.kernel.org/r/20240902042103.5867-1-zhangjiao2@cmss.chinamobile.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Message-ID: <20240902042103.5867-1-zhangjiao2@cmss.chinamobile.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/hv/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/hv/Makefile b/tools/hv/Makefile
index 2e60e2c212cd9..34ffcec264ab0 100644
--- a/tools/hv/Makefile
+++ b/tools/hv/Makefile
@@ -52,7 +52,7 @@ $(OUTPUT)hv_fcopy_uio_daemon: $(HV_FCOPY_UIO_DAEMON_IN)
 
 clean:
 	rm -f $(ALL_PROGRAMS)
-	find $(or $(OUTPUT),.) -name '*.o' -delete -o -name '\.*.d' -delete
+	find $(or $(OUTPUT),.) -name '*.o' -delete -o -name '\.*.d' -delete -o -name '\.*.cmd' -delete
 
 install: $(ALL_PROGRAMS)
 	install -d -m 755 $(DESTDIR)$(sbindir); \
-- 
2.43.0



