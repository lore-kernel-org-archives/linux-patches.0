Received: from mail.easysoft.com (mail.easysoft.com [80.195.45.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0D920311
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 04:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.195.45.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729745631; cv=none; b=I/3SCPpNDe314JqEjVznssrGyXLgds6WTo8+6evIpq9JlKQmDvvbEKhHqcLty8KNf+8UG74Qo2xcRAUeNYafv1ziddYTrRsScMzPnjwamIIaP6V+qmde/lqYrivzVKknPmcsTmC0H3xiem60m5xC0cAyzFsoWK3W4GOCzlphcTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729745631; c=relaxed/simple;
	bh=TBnqBGQmDWvZ8WQkP2sKAake7ani9NgSS4g9MTqw7cw=;
	h=To:From:Subject:Message-Id:Date; b=DzFGHza011OhlSYRUx6lQGZU5L7caFh5U4bUsE1cgU+uP9ZN3+QnZ9Heqw06BLRdEN6YVsHZyYlw0x8b5u0x6nxh1ySjlHrPfZxLjd+rzFkCw0gIy/w6iHTFNFaoDJyr7/rLabiZV4AJKGQ7BEzL/NZ7NG9sJS7iKVOLb7D2Y3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=easysoft.com; spf=pass smtp.mailfrom=easysoft.com; dkim=pass (1024-bit key) header.d=easysoft.com header.i=@easysoft.com header.b=VQv77DNQ; arc=none smtp.client-ip=80.195.45.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=easysoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=easysoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=easysoft.com header.i=@easysoft.com header.b="VQv77DNQ"
Received: from mail.easysoft.com (localhost [127.0.0.1])
	by mail.easysoft.com (Postfix) with ESMTP id 0712B8808A7
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 05:53:45 +0100 (BST)
Authentication-Results: mail.easysoft.com (amavisd-new);
	dkim=pass (1024-bit key) reason="pass (just generated, assumed good)"
	header.d=easysoft.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=easysoft.com; h=
	date:date:message-id:subject:subject:reply-to:from:from:to; s=
	dkim; t=1729745624; x=1730609625; bh=TBnqBGQmDWvZ8WQkP2sKAake7an
	i9NgSS4g9MTqw7cw=; b=VQv77DNQi0fv2xlwb7w4lggICI7X7SKqf2beOIbf7My
	4faqUfw6vwGB2pTzPVFjAhLmG8n+OTQNbUvue/V36v6+EoeK39U8Co2fo4xGXIJd
	+5wSApMqbX1E6IjP6o35gLxS6bT4fyIFZjxeNzNGu99FkGhkBni8hlc1UMrHQhSU
	=
X-Virus-Scanned: Debian amavisd-new at mail.easysoft.com
Received: from mail.easysoft.com ([127.0.0.1])
	by mail.easysoft.com (mail.easysoft.com [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id ya80EykheHew for <patches@lists.linux.dev>;
	Thu, 24 Oct 2024 05:53:44 +0100 (BST)
Received: from modperl.easysoft.com (unknown [172.20.100.10])
	by mail.easysoft.com (Postfix) with ESMTPSA id B6417880683
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 05:53:44 +0100 (BST)
Received: by modperl.easysoft.com (Postfix, from userid 33)
	id 80ED61BF2DD; Thu, 24 Oct 2024 05:53:44 +0100 (BST)
To: patches@lists.linux.dev
From: presales@easysoft.com
Sender: presales@easysoft.com
Reply-To: presales@easysoft.com
Subject: Easysoft.com Account Activated
Message-Id: <20241024045344.80ED61BF2DD@modperl.easysoft.com>
Date: Thu, 24 Oct 2024 05:53:44 +0100 (BST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

Your easysoft.com account was successfully activated; you are now able to
download trial software.

Now that you are signed up with easysoft.com, we can offer you some additional
great benefits:

* Free trials of some of the best ODBC and JDBC Drivers on the market today.

* Access to our online knowledge base system.

* Free access to our technical helpdesk for supported or trialling customers,
  should you need assistance.

* Wider support from developers if needed.

Remember our trial licenses do not restrict you from testing our software in
the environment you are going to deploy in and against any other solutions you
are considering. We are rightly proud of our software; the quality, efficiency
and speed, comprehensiveness of our standards conformance, and our software
support.

Important: If you find that your firewall or company security policy prevents
you from downloading any of our drivers then email support@easysoft.com with
the driver you need, the platform it's for and whether you need the 32-bit
or 64-bit version and we'll get it to you.

Please do not hesitate to contact us if you require any help during your
Easysoft Product evaluation.

Thank You

Easysoft Pre-Sales Support

Email : presales@easysoft.com
Tel   : +44 (0)1937 860000
Fax   : +44 (0)1937 860001

