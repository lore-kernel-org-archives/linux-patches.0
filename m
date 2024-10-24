Received: from mail.easysoft.com (mail.easysoft.com [80.195.45.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC9216130C
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 04:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.195.45.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729744778; cv=none; b=fF7qQko+NWynRpPwKjSBCb/ZeGa3CO7rciKkLB76AdBCasIH9ooFq97dfxBSNnAGPmo+l4YKvTvGU9S9dfyTYasZhFUFQjA+Nr73cy/RFzJrAywecpfkbuqZOpP1Rv5dh/aqcXXizYRj3mkWONyAE4ED8l65Y0oKYPUVymuZN58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729744778; c=relaxed/simple;
	bh=jiCjO3kkD96zvDjaNYr7OtHLLniTk7NpEvsNbEKY7mQ=;
	h=To:From:Subject:Message-Id:Date; b=q07JO8oVY+Q/xnwphPrYRLv8tjhT3Cq+BHYoLLcaOUJkOpEv1cswTspxA/4g1XXsrkY0vQY5z6MfMDdYBDkws44xhrQ9Q7mT1xqkJ47ldkKvrYoIAsSO0JASb+Acl+LL6c25ho5Wv4YWpNvNP898/SScWRwmNVJuceF961S5XoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=easysoft.com; spf=pass smtp.mailfrom=easysoft.com; dkim=pass (1024-bit key) header.d=easysoft.com header.i=@easysoft.com header.b=bjyfMwPu; arc=none smtp.client-ip=80.195.45.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=easysoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=easysoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=easysoft.com header.i=@easysoft.com header.b="bjyfMwPu"
Received: from mail.easysoft.com (localhost [127.0.0.1])
	by mail.easysoft.com (Postfix) with ESMTP id 785618807AF
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 05:33:53 +0100 (BST)
Authentication-Results: mail.easysoft.com (amavisd-new);
	dkim=pass (1024-bit key) reason="pass (just generated, assumed good)"
	header.d=easysoft.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=easysoft.com; h=
	date:date:message-id:subject:subject:reply-to:from:from:to; s=
	dkim; t=1729744433; x=1730608434; bh=jiCjO3kkD96zvDjaNYr7OtHLLni
	Tk7NpEvsNbEKY7mQ=; b=bjyfMwPuIFPfYDhRoZ+mKEZzYAEWWa7FoEPJuwXDFNN
	PPXneB/jP8yp1gm0zVTHpiVcJc9c2ysuDFMxM/p8Vr1AWbk1FReQdhjKekGpkG/A
	1nhuTszi5sm6AvKWkIAe5NQEo4IVu36dCWuMPQndLPy8xAngEQ4ir01Z7Aybn1mQ
	=
X-Virus-Scanned: Debian amavisd-new at mail.easysoft.com
Received: from mail.easysoft.com ([127.0.0.1])
	by mail.easysoft.com (mail.easysoft.com [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 2-l3t-7A5qkY for <patches@lists.linux.dev>;
	Thu, 24 Oct 2024 05:33:53 +0100 (BST)
Received: from modperl.easysoft.com (unknown [172.20.100.10])
	by mail.easysoft.com (Postfix) with ESMTPSA id 44166880683
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 05:33:53 +0100 (BST)
Received: by modperl.easysoft.com (Postfix, from userid 33)
	id 298A11BF2DD; Thu, 24 Oct 2024 05:33:53 +0100 (BST)
To: patches@lists.linux.dev
From: presales@easysoft.com
Sender: presales@easysoft.com
Reply-To: presales@easysoft.com
Subject: Easysoft.com Account Activation
Message-Id: <20241024043353.298A11BF2DD@modperl.easysoft.com>
Date: Thu, 24 Oct 2024 05:33:53 +0100 (BST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

This is the email that is sent out to activate a new www.easysoft.com account.

Your email client may split the activation link over multiple lines
and this could prevent the registration process completing. If this
is the case then copy and paste the lines of the URL into the address
bar of your browser making sure no spaces exist between the lines.

Activation requires cookies to be enabled within your browser.
If you are not sure cookies are enabled within your browser please go
to the following location for details of how cookies are enabled.

https://www.easysoft.com/company/cookie.html

Please click on the following url to activate your account.

https://www.easysoft.com/cgi-bin/account/activate.cgi?activation_id=*2171974F740AB87A41044B9D88E674F3C7E58626

Please do not hesitate to contact us if you require any help during your
Easysoft Product evaluation.

Thank You

Easysoft Pre-Sales Support

Email : presales@easysoft.com
Tel   : +44 (0)1937 860000
Fax   : +44 (0)1937 860001

