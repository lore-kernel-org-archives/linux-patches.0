Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1184329368
	for <patches@lists.linux.dev>; Tue, 27 Jan 2026 18:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769539273; cv=none; b=mglAXO4Q124LRjs2HBQdhmtYfjWBCfNB7Mm9st4lCjj0WubJ5OKSPY8kVkpwAMfsWIFNC1c/id7K9KXbdvpZ+fHI9TvBp3QYiSsUwUqwUoGISrD0GjpJxw9aLlF97K+RSIkqiY25PwXmFELAXkFBh7Cq0oWYn3H2KMyVaUxvDxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769539273; c=relaxed/simple;
	bh=rkphZnMO8wHh8g0onFqCHga56Po/l8svJSB72PlZawU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rz5qsDxrwqipLJB6HaVIf/3zQvx/6xaUlnKGMkTa92MY4A4PP6Ej78EYwLi7w9j76JoB+kLtEvo0ccAVu3yYz1bos7jc1LQx0O15VuXqMyRJRnvQB9XD+ZSEtRl2Stxn+J0WRIgZyczeMBsuMsRds3FkEeXeypnzRaN9W6qGw60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=L0IiS2OD; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="L0IiS2OD"
Received: by linux.microsoft.com (Postfix, from userid 1216)
	id 9A46F20B7165; Tue, 27 Jan 2026 10:41:12 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9A46F20B7165
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1769539272;
	bh=rkphZnMO8wHh8g0onFqCHga56Po/l8svJSB72PlZawU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L0IiS2OD743ZCnNJphBIUIuJYGTIBX9vQFXx6mJyyJ/yOFfLstCcxYMOmLlbKHtni
	 GF+MoCf+uJ0Azhdsk4w5nttV4DisELZzT9KFkpOi60QJgozeTozpSwePDKXvbUxF9e
	 LG68HwhXP1MSv+sKSvCBYGP8h7kF4yJFbei2+eXQ=
From: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
To: hamzamahfooz@linux.microsoft.com
Cc: cascardo@igalia.com,
	gregkh@linuxfoundation.org,
	lizhi.xu@windriver.com,
	patches@lists.linux.dev,
	stable@vger.kernel.org,
	syzbot+340581ba9dceb7e06fb3@syzkaller.appspotmail.com,
	tytso@mit.edu
Subject: Re: [PATCH 6.6 176/737] perf arm-spe: Extend branch operations
Date: Tue, 27 Jan 2026 10:41:12 -0800
Message-ID: <20260127184112.458449-1-hamzamahfooz@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260127183706.458136-1-hamzamahfooz@linux.microsoft.com>
References: <20260127183706.458136-1-hamzamahfooz@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I replied to the wrong thread, please disregard this message.
