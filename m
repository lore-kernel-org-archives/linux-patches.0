Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9212E8F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:54:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13239C433C7;
	Sun, 16 Jul 2023 20:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540860;
	bh=XuUbsaab6Xq+htQmpmIlC+9EgaCijMGWYBfJ+DDAW18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JXll1+xyLMKTM4MkBeqp1hV5RgC804e7OYgZn9x+Bpi3la8uiXaLhDBq9J7m2AHGk
	 6J6kjvkKWZ2t1ypKd6w9/nODKitZ9F4bWpVW21GJZLwOjuAmyoLSOEqJB3kSo8UEjQ
	 /a0LQC1JP5MZdEwufTIyTE2S8HIJuBmFVlrRAf/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Winter <wintera@linux.ibm.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	Thorsten Winkler <twinkler@linux.ibm.com>,
	Simon Horman <simon.horman@corigine.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 513/591] s390/qeth: Fix vipa deletion
Date: Sun, 16 Jul 2023 21:50:52 +0200
Message-ID: <20230716194937.153846349@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Thorsten Winkler <twinkler@linux.ibm.com>

[ Upstream commit 80de809bd35e2a8999edf9f5aaa2d8de18921f11 ]

Change boolean parameter of function "qeth_l3_vipa_store" inside the
"qeth_l3_dev_vipa_del4_store" function from "true" to "false" because
"true" is used for adding a virtual ip address and "false" for deleting.

Fixes: 2390166a6b45 ("s390/qeth: clean up L3 sysfs code")

Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
Signed-off-by: Thorsten Winkler <twinkler@linux.ibm.com>
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/qeth_l3_sys.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/net/qeth_l3_sys.c b/drivers/s390/net/qeth_l3_sys.c
index 1082380b21f85..dba9b307020cb 100644
--- a/drivers/s390/net/qeth_l3_sys.c
+++ b/drivers/s390/net/qeth_l3_sys.c
@@ -652,7 +652,7 @@ static QETH_DEVICE_ATTR(vipa_add4, add4, 0644,
 static ssize_t qeth_l3_dev_vipa_del4_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
-	return qeth_l3_vipa_store(dev, buf, true, count, QETH_PROT_IPV4);
+	return qeth_l3_vipa_store(dev, buf, false, count, QETH_PROT_IPV4);
 }
 
 static QETH_DEVICE_ATTR(vipa_del4, del4, 0200, NULL,
-- 
2.39.2



